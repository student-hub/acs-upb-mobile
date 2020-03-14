import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationProfile,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Image(
                image:
                    AssetImage('assets/illustrations/undraw_profile_pic.png')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(authProvider.user?.displayName ?? 'Anonymous'),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (!authProvider.isAuthenticated)
            FloatingActionButton(
              onPressed: () {
                authProvider.signInAnonymously();
              },
              tooltip: 'Sign In Anonymously',
              child: Icon(Icons.account_circle),
            ),
          if (authProvider.isAuthenticated)
            FloatingActionButton(
              onPressed: () async {
                authProvider.signOut(context);
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              tooltip: 'Sign Out',
              child: Icon(Icons.exit_to_app),
            )
        ],
      ),
    );
  }
}
