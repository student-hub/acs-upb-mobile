import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key key}) : super(key: key);

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
          child: Column(
            children: <Widget>[
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      size: Theme.of(context).textTheme.subtitle2.fontSize,
                    ),
                    SizedBox(width: 4),
                    Text(
                      S.of(context).messageEmailNotVerified,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w400),
                      maxLines: 1,
                    ),
                    InkWell(
                      onTap: () {
                        authProvider.sendEmailVerification(context: context);
                      },
                      child: Text(
                        ' ' + S.of(context).actionSendVerificationAgain,
                        style: Theme.of(context)
                            .accentTextTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              AutoSizeText(
                S.of(context).messageSignInAfterVerification,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontWeight: FontWeight.w400)
                    .apply(
                        fontSizeDelta: -2, color: Theme.of(context).hintColor),
                maxLines: 1,
                overflow: TextOverflow.visible,
                minFontSize: 0,
              )
            ],
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
          SizedBox(height: 8),
          Text(
            authProvider.firebaseUser?.displayName ??
                S.of(context).stringAnonymous,
            style:
                Theme.of(context).textTheme.subtitle1.apply(fontWeightDelta: 2),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: () async {
              await Navigator.pushReplacementNamed(context, Routes.login);
              authProvider.signOut(context);
            },
            child: Text(S.of(context).actionLogOut,
                style: Theme.of(context)
                    .accentTextTheme
                    .subtitle2
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 4,
            child: Container(),
          ),
          _accountNotVerifiedFooter(context),
        ],
      ),
    );
  }
}
