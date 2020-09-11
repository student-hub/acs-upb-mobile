import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension MapUtils<K, V> on Map<K, V> {
  V getIfPresent(K key) {
    if (this.containsKey(key)) {
      return this[key];
    } else {
      return null;
    }
  }
}

extension DatabaseUser on User {
  static User fromSnap(DocumentSnapshot snap) {
    String degree;
    String domain;
    String year;
    String series;
    String group;
    String picture;

    if (snap.data.containsKey('class')) {
      degree = snap.data['class']['degree'];
      domain = snap.data['class']['domain'];
      year = snap.data['class']['year'];
      series = snap.data['class']['series'];
      group = snap.data['class']['group'];
      picture = snap.data['class']['picture'];
    }

    return User(
        uid: snap.documentID,
        firstName: snap.data['name']['first'],
        lastName: snap.data['name']['last'],
        degree: degree,
        domain: domain,
        year: year,
        series: series,
        group: group,
        picture: picture,
        permissionLevel: snap.data['permissionLevel']);
  }

  Map<String, dynamic> toData() {
    Map<String, String> classInfo = {};
    if (degree != null) classInfo['degree'] = degree;
    if (domain != null) classInfo['domain'] = domain;
    if (year != null) classInfo['year'] = year;
    if (series != null) classInfo['series'] = series;
    if (group != null) classInfo['group'] = group;
    if (picture != null) classInfo['picture'] = picture;

    return {
      'name': {'first': firstName, 'last': lastName},
      'class': classInfo,
      'permissionLevel': permissionLevel
    };
  }
}

class AuthProvider with ChangeNotifier {
  FirebaseUser _firebaseUser;
  StreamSubscription _userAuthSub;
  User _currentUser;

  AuthProvider() {
    _userAuthSub = FirebaseAuth.instance.onAuthStateChanged.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      _firebaseUser = newUser;
      _fetchUser();
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  @override
  void dispose() {
    if (_userAuthSub != null) {
      _userAuthSub.cancel();
      _userAuthSub = null;
    }
    super.dispose();
  }

  void _errorHandler(e, context) {
    try {
      print(e.message);
      if (context != null) {
        switch (e.code) {
          case 'ERROR_INVALID_EMAIL':
          case 'ERROR_INVALID_CREDENTIAL':
            AppToast.show(S.of(context).errorInvalidEmail);
            break;
          case 'ERROR_WRONG_PASSWORD':
            AppToast.show(S.of(context).errorIncorrectPassword);
            break;
          case 'ERROR_USER_NOT_FOUND':
            AppToast.show(S.of(context).errorEmailNotFound);
            break;
          case 'ERROR_USER_DISABLED':
            AppToast.show(S.of(context).errorAccountDisabled);
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
            AppToast.show(S.of(context).errorTooManyRequests +
                ' ' +
                S.of(context).warningTryAgainLater);
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            AppToast.show(S.of(context).errorEmailInUse);
            break;
          default:
            AppToast.show(e.message);
        }
      }
    } catch (_) {
      // Unknown exception
      print(e);
      AppToast.show(S.of(context).errorSomethingWentWrong);
    }
  }

  bool get isAnonymous {
    if (_firebaseUser == null) {
      return true;
    }

    bool isAnonymousUser = true;
    for (UserInfo info in _firebaseUser.providerData) {
      if (info.providerId == 'facebook.com' ||
          info.providerId == 'google.com' ||
          info.providerId == 'password') {
        isAnonymousUser = false;
        break;
      }
    }
    return isAnonymousUser;
  }

  /// Check the memory cache to see if there is a user authenticated
  bool get isVerifiedFromCache {
    assert(_firebaseUser != null);
    return !isAnonymous && _firebaseUser.isEmailVerified;
  }

  /// Check the network to see if there is a user authenticated
  Future<bool> get isVerifiedFromService async {
    if (isAnonymous) {
      return false;
    }

    await _firebaseUser.reload();
    _firebaseUser = await FirebaseAuth.instance.currentUser();
    return _firebaseUser.isEmailVerified;
  }

  /// Check the memory cache to see if there is a user authenticated
  bool get isAuthenticatedFromCache {
    return _firebaseUser != null;
  }

  /// Check the filesystem to see if there is a user authenticated.
  ///
  /// This method is [async] and should only be necessary on app startup, since
  /// for everything else, the [AuthProvider] will notify its listeners and
  /// update the cache if the authentication state changes.
  Future<bool> get isAuthenticatedFromService async {
    _firebaseUser = await FirebaseAuth.instance.currentUser();
    return _firebaseUser != null;
  }

  String get uid {
    return _firebaseUser.uid;
  }

  Future<User> _fetchUser() async {
    if (isAnonymous) {
      return null;
    }
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(_firebaseUser.uid)
        .get();

    _currentUser = DatabaseUser.fromSnap(snapshot);
    return _currentUser;
  }

  Future<User> get currentUser => _fetchUser();

  User get currentUserFromCache => _currentUser;

  Future<bool> signInAnonymously({BuildContext context}) async {
    return FirebaseAuth.instance.signInAnonymously().catchError((e) {
      _errorHandler(e, context);
      return false;
    }).then((_) => true);
  }

  Future<bool> signIn(
      {String email, String password, BuildContext context}) async {
    if (email == null || email == '') {
      AppToast.show(S.of(context).errorInvalidEmail);
      return false;
    } else if (password == null || password == '') {
      AppToast.show(S.of(context).errorNoPassword);
      return false;
    }

    List<String> providers = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: email)
        .catchError((e) {
      _errorHandler(e, context);
      return false;
    });

    // An error occurred (and was already handled)
    if (providers == null) {
      return false;
    }

    // User has an account with a different provider
    if (providers.isNotEmpty && !providers.contains('password')) {
      AppToast.show(S.of(context).warningUseProvider(providers[0]));
      return false;
    }

    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _errorHandler(e, context);
      return false;
    }).then((_) => true);
  }

  Future<void> signOut(BuildContext context) async {
    if (isAnonymous) {
      delete();
    }

    Provider.of<FilterProvider>(context, listen: false).resetFilter();
    return await FirebaseAuth.instance.signOut();
  }

  Future<bool> delete({BuildContext context}) async {
    if (_firebaseUser == null) {
      _firebaseUser = await FirebaseAuth.instance.currentUser();
    }

    assert(_firebaseUser != null);

    try {
      DocumentReference ref =
          Firestore.instance.collection('users').document(_firebaseUser.uid);
      await ref.delete();

      await _firebaseUser.delete();
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }

    if (context != null) {
      AppToast.show(S.of(context).messageAccountDeleted);
    }
    return true;
  }

  Future<bool> canSignInWithPassword(
      {String email, BuildContext context}) async {
    List<String> providers = [];
    try {
      providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
    bool accountExists = providers.contains('password');
    if (!accountExists && context != null) {
      AppToast.show(S.of(context).errorEmailNotFound);
    }
    return accountExists;
  }

  Future<bool> canSignUpWithEmail({String email, BuildContext context}) async {
    List<String> providers = [];
    try {
      providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
    bool accountExists = providers.isNotEmpty;
    if (accountExists && context != null) {
      AppToast.show(S.of(context).warningEmailInUse(email));
    }
    return !accountExists;
  }

  Future<bool> sendPasswordResetEmail(
      {String email, BuildContext context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (context != null) {
        AppToast.show(S.of(context).infoPasswordResetEmailSent);
      }
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  /// Create a new user with the data in [info].
  Future<bool> signUp({Map<String, String> info, BuildContext context}) async {
    try {
      String email = info[S.of(context).labelEmail];
      String password = info[S.of(context).labelPassword];
      String confirmPassword = info[S.of(context).labelConfirmPassword];
      String firstName = info[S.of(context).labelFirstName];
      String lastName = info[S.of(context).labelLastName];

      Filter filter =
          Provider.of<FilterProvider>(context, listen: false).cachedFilter;
      String degree = info.getIfPresent(
          filter.localizedLevelNames[0][LocaleProvider.localeString]);
      String domain = info.getIfPresent(
          filter.localizedLevelNames[1][LocaleProvider.localeString]);
      String year = info.getIfPresent(
          filter.localizedLevelNames[2][LocaleProvider.localeString]);
      String series = info.getIfPresent(
          filter.localizedLevelNames[3][LocaleProvider.localeString]);
      String group = info.getIfPresent(
          filter.localizedLevelNames[4][LocaleProvider.localeString]);

      if (email == null || email == '') {
        AppToast.show(S.of(context).errorInvalidEmail);
        return false;
      } else if (password == null || password == '') {
        AppToast.show(S.of(context).errorNoPassword);
        return false;
      }
      if (confirmPassword == null || confirmPassword != password) {
        AppToast.show(S.of(context).errorPasswordsDiffer);
        return false;
      }
      if (firstName == null || firstName == '') {
        AppToast.show(S.of(context).errorMissingFirstName);
        return false;
      }
      if (lastName == null || lastName == '') {
        AppToast.show(S.of(context).errorMissingLastName);
        return false;
      }
      if (!await AppValidator.isStrongPassword(
          password: password, context: context)) {
        return false;
      }

      // Create user
      AuthResult res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = firstName + ' ' + lastName;
      await res.user.updateProfile(userUpdateInfo);

      // Update user with updated info
      await _firebaseUser?.reload();
      _firebaseUser = await FirebaseAuth.instance.currentUser();

      // Create document in 'users'
      var user = User(
          uid: res.user.uid,
          firstName: firstName,
          lastName: lastName,
          degree: degree,
          domain: domain,
          year: year,
          series: series,
          group: group);

      DocumentReference ref =
          Firestore.instance.collection('users').document(user.uid);
      await ref.setData(user.toData());

      // Send verification e-mail
      await _firebaseUser.sendEmailVerification();

      if (context != null) {
        AppToast.show(S.of(context).messageAccountCreated +
            ' ' +
            S.of(context).messageCheckEmailVerification);
      }

      notifyListeners();
      return true;
    } catch (e) {
      // Remove user if it was created
      await _firebaseUser?.delete();

      _errorHandler(e, context);
      return false;
    }
  }

  Future<bool> sendEmailVerification({BuildContext context}) async {
    try {
      await _firebaseUser.sendEmailVerification();
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }

    if (context != null) {
      AppToast.show(S.of(context).messageCheckEmailVerification);
    }
    return true;
  }

  ///Update the user information with the data in [info].
  Future<bool> updateProfile(
      {Map<String, String> info, BuildContext context}) async {
    try {
      String firstName = info[S.of(context).labelFirstName];
      String lastName = info[S.of(context).labelLastName];

      Filter filter =
          Provider.of<FilterProvider>(context, listen: false).cachedFilter;
      String degree = info.getIfPresent(
          filter.localizedLevelNames[0][LocaleProvider.localeString]);
      String domain = info.getIfPresent(
          filter.localizedLevelNames[1][LocaleProvider.localeString]);
      String year = info.getIfPresent(
          filter.localizedLevelNames[2][LocaleProvider.localeString]);
      String series = info.getIfPresent(
          filter.localizedLevelNames[3][LocaleProvider.localeString]);
      String group = info.getIfPresent(
          filter.localizedLevelNames[4][LocaleProvider.localeString]);
      String subgroup = info.getIfPresent(
          filter.localizedLevelNames[5][LocaleProvider.localeString]);

      if (firstName == null || firstName == '') {
        AppToast.show(S.of(context).errorMissingFirstName);
        return false;
      }
      if (lastName == null || lastName == '') {
        AppToast.show(S.of(context).errorMissingLastName);
        return false;
      }
      User user =
          await Provider.of<AuthProvider>(context, listen: false).currentUser;
      user.firstName = firstName;
      user.lastName = lastName;
      user.degree = degree;
      user.domain = domain;
      user.year = year;
      user.series = series;
      user.group = group;
      //user.subgroup = subgroup;
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData(user.toData());

      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = firstName + ' ' + lastName;
      _firebaseUser.updateProfile(userUpdateInfo);
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }
}
