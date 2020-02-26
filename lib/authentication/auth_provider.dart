import 'dart:async';

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

  void signInAnonymously() {
    FirebaseAuth.instance.signInAnonymously();
  }

  void signIn({String email, String password}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<bool> canSignInWithPassword({String email}) async {
    if (email == null || email == "") {
      return null;
    }

    List<String> providers = [];
    try {
      providers =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    } catch (e) {
      return false;
    }

    return providers?.contains('password');
  }
}
