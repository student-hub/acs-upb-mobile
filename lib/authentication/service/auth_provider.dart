import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension DatabaseUser on User {
  static User fromSnap(DocumentSnapshot snap) {
    return User(
        uid: snap.documentID,
        firstName: snap.data['name']['first'],
        lastName: snap.data['name']['last'],
        classes: List.from(snap.data['class'] ?? []),
        permissionLevel: snap.data['permissionLevel']);
  }

  Map<String, dynamic> toData() {
    return {
      'name': {'first': firstName, 'last': lastName},
      'class': classes,
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

  String get email => _firebaseUser.email;

  bool isOldFormat(Map<String, dynamic> userData) =>
      userData['class'] != null && userData['class'] is Map;

  /// Change the `class` of the user data in Firebase to the new format.
  ///
  /// The old format of class in the database is a `Map<String, String>`,
  /// where the key is the name of the level in the filter tree.
  /// In the new format, the class is simply a `List<String>` that contains the
  /// name of the nodes.
  Future<void> migrateToNewClassFormat(Map<String, dynamic> userData) async {
    List<String> classes = [
      'degree',
      'domain',
      'year',
      'series',
      'group',
      'subgroup'
    ]
        .map((key) => userData['class'][key].toString())
        .where((s) => s != 'null')
        .toList();

    userData['class'] = classes;

    await Firestore.instance
        .collection('users')
        .document(_firebaseUser.uid)
        .updateData(userData);
  }

  Future<User> _fetchUser() async {
    if (isAnonymous) {
      return null;
    }
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(_firebaseUser.uid)
        .get();
    if (snapshot.data == null) return null;

    if (isOldFormat(snapshot.data))
      await migrateToNewClassFormat(snapshot.data);

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

  Future<bool> changePassword({String password, BuildContext context}) async {
    bool result = false;
    await _firebaseUser.updatePassword(password).then((_) {
      AppToast.show(S.of(context).messageChangePasswordSuccess);
      result = true;
    });
    return result;
  }

  Future<bool> changeEmail({String email, BuildContext context}) async {
    bool result = false;
    await _firebaseUser.updateEmail(email).then((_) {
      AppToast.show(S.of(context).messageChangeEmailSuccess);
      result = true;
    });
    return result;
  }

  Future<bool> verifyPassword({String password, BuildContext context}) async {
    return await signIn(
        email: _firebaseUser.email, password: password, context: context);
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
      return null;
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

    AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _errorHandler(e, context);
      return null;
    });
    return result != null;
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
  Future<bool> signUp({Map<String, dynamic> info, BuildContext context}) async {
    try {
      String email = info[S.of(context).labelEmail];
      String password = info[S.of(context).labelPassword];
      String confirmPassword = info[S.of(context).labelConfirmPassword];
      String firstName = info[S.of(context).labelFirstName];
      String lastName = info[S.of(context).labelLastName];

      List<String> classes = info['class'] ?? null;

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
        classes: classes,
      );

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

  /// Update the user information with the data in [info].
  Future<bool> updateProfile(
      {Map<String, dynamic> info, BuildContext context}) async {
    try {
      String firstName = info[S.of(context).labelFirstName];
      String lastName = info[S.of(context).labelLastName];

      List<String> classes = info['class'] ?? null;

      User user =
          await Provider.of<AuthProvider>(context, listen: false).currentUser;
      user.firstName = firstName;
      user.lastName = lastName;
      user.classes = classes;

      Firestore.instance
          .collection('users')
          .document(user.uid)
          .updateData(user.toData());

      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = firstName + ' ' + lastName;
      await _firebaseUser.updateProfile(userUpdateInfo);

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }
}
