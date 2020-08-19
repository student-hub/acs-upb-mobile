import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/faq/faqPage.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: S.of(context).navigationHome,
      actions: [
        AppScaffoldAction(
          icon: Icons.settings,
          tooltip: S.of(context).navigationSettings,
          route: Routes.settings,
        )
      ],
      body: Center(
        child: FutureBuilder(
          future: authProvider.currentUser,
          builder: (BuildContext context, AsyncSnapshot<User> snap) {
            String firstName;
            if (snap.hasData) {
              User user = snap.data;
              firstName = user.firstName;
            }
            return FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) { return FaqPage(); }));
              },
              child: Text(firstName == null
                  ? S.of(context).messageWelcomeSimple
                  : S.of(context).messageWelcomeName(firstName)),
            );
          },
        ),
      ),
    );
  }
}
