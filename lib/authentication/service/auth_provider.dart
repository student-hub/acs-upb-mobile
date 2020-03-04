import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension DatabaseUser on User {
  static User fromSnap(DocumentSnapshot snap) {
    return User(uid: snap.documentID, firstName: snap.data['name']['first'], lastName: snap.data['name']['last'],
    group: snap.data['group']);
  }

  Map<String, dynamic> toData() {
    return {
      'name': {'first': firstName, 'last': lastName},
      'group': group
    };
  }
}

class AuthProvider with ChangeNotifier {
  FirebaseUser user;
  StreamSubscription userAuthSub;

  AuthProvider() {
    userAuthSub = FirebaseAuth.instance.onAuthStateChanged.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      user = newUser;
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
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
          AppToast.show(e.message);
      }
    }
  }

  bool get isAnonymous {
    assert(user != null);
    bool isAnonymousUser = true;
    for (UserInfo info in user.providerData) {
      if (info.providerId == 'facebook.com' ||
          info.providerId == 'google.com' ||
          info.providerId == 'password') {
        isAnonymousUser = false;
        break;
      }
    }
    return isAnonymousUser;
  }

  bool get isAuthenticated {
    return user != null;
  }

  Future<User> getCurrentUser() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();
    return DatabaseUser.fromSnap(snapshot);
  }

  Future<AuthResult> signInAnonymously({BuildContext context}) async {
    return FirebaseAuth.instance.signInAnonymously().catchError((e) {
      _errorHandler(e, context);
      return null;
    });
  }

  Future<AuthResult> signIn(
      {String email, String password, BuildContext context}) async {
    if (email == null || email == '') {
      AppToast.show(S.of(context).errorInvalidEmail);
      return null;
    } else if (password == null || password == '') {
      AppToast.show(S.of(context).errorNoPassword);
      return null;
    }

    List<String> providers = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: email)
        .catchError((e) {
      _errorHandler(e, context);
      return null;
    });

    // An error occurred (and was already handled)
    if (providers == null) {
      return null;
    }

    // User has an account with a different provider
    if (providers.isNotEmpty && !providers.contains('password')) {
      AppToast.show(S.of(context).warningUseProvider(providers[0]));
      return null;
    }

    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _errorHandler(e, context);
      return null;
    });
  }

  Future<void> signOut() {
    if (isAnonymous) {
      try {
        user.delete();
      } catch (e) {
        _errorHandler(e, null);
      }
    }
    return FirebaseAuth.instance.signOut();
  }

  Future<bool> canSignInWithPassword({String email}) async {
    List<String> providers = [];
    try {
      providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } catch (e) {
      _errorHandler(e, null);
      return false;
    }
    return providers.contains('password');
  }

  Future<bool> canSignUpWithEmail({String email}) async {
    List<String> providers = [];
    try {
      providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } catch (e) {
      _errorHandler(e, null);
      return false;
    }
    return providers.isEmpty;
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
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      if (context != null) {
        AppToast.show(S.of(context).warningPasswordCharacters);
      }
      return false;
    }
    return true;
  }

  /// Create a new user with the data in [info].
  Future<User> signUp({Map<String, String> info, BuildContext context}) async {
    String email = info[S.of(context).labelEmail];
    String password = info[S.of(context).labelPassword];
    String confirmPassword = info[S.of(context).labelConfirmPassword];
    String firstName = info[S.of(context).labelFirstName];
    String lastName = info[S.of(context).labelLastName];
    String group = info[S.of(context).labelGroup];

    if (email == null || email == '') {
      AppToast.show(S.of(context).errorInvalidEmail);
      return null;
    } else if (password == null || password == '') {
      AppToast.show(S.of(context).errorNoPassword);
      return null;
    }
    if (confirmPassword == null || confirmPassword != password) {
      AppToast.show(S.of(context).errorPasswordsDiffer);
      return null;
    }
    if (firstName == null || firstName == '') {
      AppToast.show(S.of(context).errorMissingFirstName);
      return null;
    }
    if (lastName == null || lastName == '') {
      AppToast.show(S.of(context).errorMissingLastName);
      return null;
    }
    if (!await isStrongPassword(password: password, context: context)) {
      return null;
    }

    try {
      // Create user
      AuthResult res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      try {
        var userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = firstName + ' ' + lastName;
        await res.user.updateProfile(userUpdateInfo);
        Navigator.pop(context, true);
      } catch (e) {
        _errorHandler(e, context);
      }

      // Create document in 'users'
      var user = User(
          uid: res.user.uid,
          firstName: firstName,
          lastName: lastName,
          group: group);

      DocumentReference ref =
          Firestore.instance.collection('users').document(user.uid);
      ref.setData(user.toData());

      AppToast.show(S.of(context).messageAccountCreated);
      return user;
    } catch (e) {
      _errorHandler(e, context);
      return null;
    }
  }
}
