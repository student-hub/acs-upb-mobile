import 'package:acs_upb_mobile/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);

    return AppScaffold(
        title: S.of(context).drawerHeaderHome,
        body: Center(
            child: Text(authProvider.isAnonymous
                ? S.of(context).welcomeSimple
                : S.of(context).welcomeName(authProvider.user.displayName))));
  }
}
