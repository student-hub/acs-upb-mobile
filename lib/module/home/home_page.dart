import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widget/scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: S.of(context).drawerHeaderHome,
        body: Center(child: Text(S.of(context).drawerHeaderHome)));
  }
}
