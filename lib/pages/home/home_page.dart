import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  final FirebaseUser user;

  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: S.of(context).drawerHeaderHome,
        body: Center(
            child: Text(user != null
                ? S.of(context).welcomeName(user.displayName)
                : S.of(context).welcomeSimple)));
  }
}
