import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationHome,
      actions: [
        AppScaffoldAction(
          icon: Icons.settings,
          tooltip: S.of(context).navigationSettings,
          route: Routes.settings,
        )
      ],
      body: ListView(
        children: [
          ProfileCard(),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return FutureBuilder(
      future: authProvider.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User> snap) {
        if (snap.connectionState == ConnectionState.done) {
          String userName;
          String userGroup;
          User user = snap.data;
          if (user != null) {
            userName = user.firstName + ' ' + user.lastName;
            userGroup = user.classes != null ? user.classes.last : null;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircleAvatar(
                            radius: 40,
                            child: Image(
                                image: AssetImage(
                                    'assets/illustrations/undraw_profile_pic.png')),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    userName ?? S.of(context).stringAnonymous,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .apply(fontWeightDelta: 2),
                                  ),
                                ),
                                if (userGroup != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(userGroup,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ),
                                InkWell(
                                  onTap: () {
                                    Utils.signOut(context);
                                  },
                                  child: Text(
                                      authProvider.isAnonymous
                                          ? S.of(context).actionLogIn
                                          : S.of(context).actionLogOut,
                                      style: Theme.of(context)
                                          .accentTextTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(user != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Theme.of(context).textTheme.button.color,
                              onPressed: ()  => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AccountNotVerifiedWarning(),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
