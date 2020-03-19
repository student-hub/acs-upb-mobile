import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
        title: S.of(context).navigationHome,
        enableMenu: true,
        body: Center(
            child: Text(
                !authProvider.isAuthenticatedFromCache || authProvider.isAnonymous
                    ? S.of(context).messageWelcomeSimple
                    : S.of(context).messageWelcomeName(
                        authProvider.firebaseUser.displayName))));
  }
}
