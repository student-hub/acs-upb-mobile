import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _accountNotVerifiedFooter(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticatedFromCache || authProvider.isAnonymous) {
      return Container();
    }

    return FutureBuilder(
      future: authProvider.isVerifiedFromService,
      builder: (BuildContext context, AsyncSnapshot<bool> snap) {
        if (!snap.hasData || snap.data) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconText(
            align: TextAlign.center,
            icon: Icons.error_outline,
            text: S.of(context).messageEmailNotVerified,
            actionText: S.of(context).actionSendVerificationAgain,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w400),
            onTap: () => authProvider.sendEmailVerification(context: context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return AppScaffold(
      actions: [
        AppScaffoldAction(
            icon: Icons.edit,
            tooltip: S.of(context).actionEditProfile,
            onPressed: (authProvider.isAnonymous ||
                    !authProvider.isAuthenticatedFromCache)
                ? null
                : () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfilePage()));
                  })
      ],
      title: S.of(context).navigationProfile,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: authProvider.currentUser,
            builder: (BuildContext context, AsyncSnapshot<User> snap) {
              String userName;
              String userGroup;
              if (snap.connectionState == ConnectionState.done) {
                User user = snap.data;
                if (user != null) {
                  userName = user.firstName + ' ' + user.lastName;
                  userGroup = user.classes == null ? user.classes.last: null;
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    CircleAvatar(
                        radius: 95,
                        backgroundImage: AssetImage(
                            'assets/illustrations/undraw_profile_pic.png')),
                    SizedBox(height: 8),
                    Text(
                      userName ?? S.of(context).stringAnonymous,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(fontWeightDelta: 2),
                    ),
                    if (userGroup != null)
                      Column(
                        children: [
                          SizedBox(height: 4),
                          Text(userGroup,
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    SizedBox(height: 8),
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
                              .copyWith(fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                    _accountNotVerifiedFooter(context),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
