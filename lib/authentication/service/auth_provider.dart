import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension DatabaseUser on User {
  static User fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return User(
        uid: snap.id,
        firstName: data['name']['first'],
        lastName: data['name']['last'],
        classes: List.from(data['class'] ?? []),
        permissionLevel: data['permissionLevel']);
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
  AuthProvider() {
    _userAuthSub = _auth.authStateChanges().listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      _currentUser = null;
      _fetchUser();
      notifyListeners();
    }, onError: (dynamic e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  StreamSubscription<auth.User> _userAuthSub;
  User _currentUser;
  final _auth = auth.FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  void dispose() {
    if (_userAuthSub != null) {
      _userAuthSub.cancel();
      _userAuthSub = null;
    }
    super.dispose();
  }

  void _errorHandler(dynamic e, BuildContext context) {
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
            AppToast.show(
                '${S.of(context).errorTooManyRequests} ${S.of(context).warningTryAgainLater}');
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
    if (_auth.currentUser == null) {
      return true;
    }

    var isAnonymousUser = true;
    for (final info in _auth.currentUser.providerData) {
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
    assert(_auth.currentUser != null);
    return !isAnonymous && _auth.currentUser.emailVerified;
  }

  /// Check the network to see if there is a user authenticated
  Future<bool> get isVerifiedFromService async {
    if (isAnonymous) {
      return false;
    }

    await _auth.currentUser.reload();
    return _auth.currentUser.emailVerified;
  }

  /// Check the memory cache to see if there is a user authenticated
  bool get isAuthenticated {
    return _auth.currentUser != null;
  }

  String get uid {
    return _auth.currentUser.uid;
  }

  String get email => _auth.currentUser.email;

  bool isOldFormat(Map<String, dynamic> userData) =>
      userData['class'] != null && userData['class'] is Map;

  /// Change the `class` of the user data in Firebase to the new format.
  ///
  /// The old format of class in the database is a `Map<String, String>`,
  /// where the key is the name of the level in the filter tree.
  /// In the new format, the class is simply a `List<String>` that contains the
  /// name of the nodes.
  Future<void> migrateToNewClassFormat(Map<String, dynamic> userData) async {
    final classes = ['degree', 'domain', 'year', 'series', 'group', 'subgroup']
        .map((key) => userData['class'][key].toString())
        .where((s) => s != 'null')
        .toList();

    userData['class'] = classes;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update(userData);
  }

  Future<User> _fetchUser() async {
    if (isAnonymous) {
      return null;
    }
    final snapshot =
        await _db.collection('users').doc(_auth.currentUser.uid).get();
    if (snapshot.data == null) return null;

    if (isOldFormat(snapshot.data())) {
      await migrateToNewClassFormat(snapshot.data());
    }

    _currentUser = DatabaseUser.fromSnap(snapshot);
    notifyListeners();
    return _currentUser;
  }

  Future<User> get currentUser => _fetchUser();

  User get currentUserFromCache => _currentUser;

  Future<bool> signInAnonymously({BuildContext context}) async {
    return _auth.signInAnonymously().catchError((dynamic e) {
      _errorHandler(e, context);
      return false;
    }).then((_) => true);
  }

  Future<bool> changePassword({String password, BuildContext context}) async {
    bool result = false;
    await _auth.currentUser.updatePassword(password).then((_) {
      result = true;
    }).catchError((dynamic e) {
      _errorHandler(e, context);
      result = false;
    });
    return result;
  }

  Future<bool> changeEmail({String email, BuildContext context}) async {
    bool result = false;
    await _auth.currentUser.updateEmail(email).then((_) {
      result = true;
    }).catchError((dynamic e) {
      _errorHandler(e, context);
      result = false;
    });
    return result;
  }

  Future<bool> verifyPassword({String password, BuildContext context}) async {
    return signIn(
        email: _auth.currentUser.email, password: password, context: context);
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

    final List<String> providers =
        await _auth.fetchSignInMethodsForEmail(email).catchError((dynamic e) {
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

    final result = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic e) {
      _errorHandler(e, context);
      return null;
    });
    await _fetchUser();
    return result != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    if (isAnonymous) {
      await delete();
    }
  }

  Future<bool> delete({BuildContext context}) async {
    assert(_auth.currentUser != null);

    try {
      final DocumentReference ref =
          _db.collection('users').doc(_auth.currentUser.uid);
      await ref.delete();

      await _auth.currentUser.delete();
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
      providers = await _auth.fetchSignInMethodsForEmail(email);
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
    final bool accountExists = providers.contains('password');
    if (!accountExists && context != null) {
      AppToast.show(S.of(context).errorEmailNotFound);
    }
    return accountExists;
  }

  Future<bool> canSignUpWithEmail({String email, BuildContext context}) async {
    List<String> providers = [];
    try {
      providers = await _auth.fetchSignInMethodsForEmail(email);
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
    final bool accountExists = providers.isNotEmpty;
    if (accountExists && context != null) {
      AppToast.show(S.of(context).warningEmailInUse(email));
    }
    return !accountExists;
  }

  Future<bool> sendPasswordResetEmail(
      {String email, BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

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
      final email = info[S.of(context).labelEmail];
      final password = info[S.of(context).labelPassword];
      final confirmPassword = info[S.of(context).labelConfirmPassword];
      final firstName = info[S.of(context).labelFirstName];
      final lastName = info[S.of(context).labelLastName];

      final classes = info['class'];

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

      final errorString = AppValidator.isStrongPassword(password, context);
      if (errorString != null) {
        AppToast.show(errorString);
        return false;
      }

      // Create user
      final auth.UserCredential res = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await res.user.updateProfile(displayName: '$firstName $lastName');

      // Update user with updated info
      await _auth.currentUser?.reload();

      // Create doc in 'users'
      final user = User(
        uid: res.user.uid,
        firstName: firstName,
        lastName: lastName,
        classes: classes,
      );

      final DocumentReference ref = _db.collection('users').doc(user.uid);
      await ref.set(user.toData());

      // Send verification e-mail
      await _auth.currentUser.sendEmailVerification();

      if (context != null) {
        AppToast.show(
            '${S.of(context).messageAccountCreated} ${S.of(context).messageCheckEmailVerification}');
      }

      notifyListeners();
      return true;
    } catch (e) {
      // Remove user if it was created
      await _auth.currentUser?.delete();

      _errorHandler(e, context);
      return false;
    }
  }

  Future<bool> sendEmailVerification({BuildContext context}) async {
    try {
      await _auth.currentUser.sendEmailVerification();
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
      final firstName = info[S.of(context).labelFirstName];
      final lastName = info[S.of(context).labelLastName];

      final classes = info['class'];

      final User user =
          await Provider.of<AuthProvider>(context, listen: false).currentUser
            ..firstName = firstName
            ..lastName = lastName
            ..classes = classes;

      await _db.collection('users').doc(user.uid).update(user.toData());

      // Update display name
      await _auth.currentUser
          .updateProfile(displayName: '$firstName $lastName');

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }
}
