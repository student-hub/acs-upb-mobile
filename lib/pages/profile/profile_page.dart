import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: title,
      body: Container(),
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
                authProvider.signOut();
                Navigator.popAndPushNamed(context, Routes.login);
              },
              tooltip: 'Sign Out',
              child: Icon(Icons.exit_to_app),
            )
        ],
      ),
    );
  }
}
