import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        default:
          AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }
  }

  bool get isAnonymous {
    assert(user != null);
    bool isAnonymousUser = true;
    for (UserInfo info in user.providerData) {
      if (info.providerId == "facebook.com" ||
          info.providerId == "google.com" ||
          info.providerId == "password") {
        isAnonymousUser = false;
        break;
      }
    }
    return isAnonymousUser;
  }

  bool get isAuthenticated {
    return user != null;
  }

  Future<AuthResult> signInAnonymously({BuildContext context}) async {
    return FirebaseAuth.instance.signInAnonymously().catchError((e) {
      _errorHandler(e, context);
    });
  }

  Future<AuthResult> signIn(
      {String email, String password, BuildContext context}) async {
    if (email == null || email == "") {
      AppToast.show(S.of(context).errorInvalidEmail);
      return null;
    } else if (password == null || password == "") {
      AppToast.show(S.of(context).errorNoPassword);
      return null;
    }

    List<String> providers = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: email)
        .catchError((e) {
      _errorHandler(e, context);
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
    });
  }

  Future<void> signOut() {
    if (isAnonymous) {
      user.delete();
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
    } catch(e) {
      _errorHandler(e, context);
      return false;
    }
  }
}
