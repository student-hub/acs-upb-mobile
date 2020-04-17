import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
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
        group: snap.data['group'],
        permissionLevel: snap.data['permissionLevel']);
  }

  Map<String, dynamic> toData() {
    return {
      'name': {'first': firstName, 'last': lastName},
      'group': group,
      'permissionLevel': permissionLevel
    };
  }
}

class AuthProvider with ChangeNotifier {
  FirebaseUser _firebaseUser;
  StreamSubscription _userAuthSub;

  AuthProvider() {
    _userAuthSub = FirebaseAuth.instance.onAuthStateChanged.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      _firebaseUser = newUser;
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
          AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }
  }

  bool get isAnonymous {
    assert(_firebaseUser != null);
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
    return _firebaseUser.isEmailVerified;
  }

  /// Check the network to see if there is a user authenticated
  Future<bool> get isVerifiedFromService async {
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

  Future<User> get currentUser async {
    if (isAnonymous) {
      return null;
    }
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(_firebaseUser.uid)
        .get();
    return DatabaseUser.fromSnap(snapshot);
  }

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
      ref?.delete();

      _firebaseUser.delete();
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

  Future<bool> isStrongPassword({String password, BuildContext context}) async {
    if (password.length < 8) {
      if (context != null) {
        AppToast.show(S.of(context).warningPasswordLength);
      }
      return false;
    }
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      if (context != null) {
        AppToast.show(S.of(context).warningPasswordCharacters);
      }
      return false;
    }
    return true;
  }

  /// Create a new user with the data in [info].
  Future<bool> signUp({Map<String, String> info, BuildContext context}) async {
    String email = info[S.of(context).labelEmail];
    String password = info[S.of(context).labelPassword];
    String confirmPassword = info[S.of(context).labelConfirmPassword];
    String firstName = info[S.of(context).labelFirstName];
    String lastName = info[S.of(context).labelLastName];
    String group = info[S.of(context).labelGroup];

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
    if (!await isStrongPassword(password: password, context: context)) {
      return false;
    }

    try {
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
}
