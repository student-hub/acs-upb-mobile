import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: Icon(Icons.warning, color: Colors.red),
        title: S.of(context).actionDeleteAccount,
        message: S.of(context).messageDeleteAccount +
            ' ' +
            S.of(context).messageCannotBeUndone,
        actions: [
          AppButton(
            key: ValueKey('delete_account_button'),
            text: S.of(context).actionDeleteAccount.toUpperCase(),
            color: Colors.red,
            width: 130,
            onTap: () async {
              AuthProvider authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              bool res = await authProvider.delete(context: context);
              if (res) {
                _signOut(context);
              }
            },
          )
        ],
      );

  Widget _deleteAccountButton(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticatedFromCache || authProvider.isAnonymous) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconText(
          onTap: () async {
            showDialog(context: context, builder: _deletionConfirmationDialog);
          },
          icon: Icons.delete,
          text: S.of(context).actionDeleteAccount,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .apply(color: Colors.red, fontWeightDelta: 1)),
    );
  }

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
                  userGroup = user.group;
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image(
                          image: AssetImage(
                              'assets/illustrations/undraw_profile_pic.png')),
                    ),
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
                        _signOut(context);
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
                    _deleteAccountButton(context),
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
