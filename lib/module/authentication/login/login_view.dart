import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/module/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widget/button.dart';
import 'package:acs_upb_mobile/widget/form_card.dart';
import 'package:acs_upb_mobile/widget/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView();

  @override
  _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    AuthProvider authProvider = Provider.of(context);

    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Container(
                    height: ScreenUtil().setHeight(400),
                    child: Image.asset(
                        "assets/illustrations/undraw_digital_nomad.png")),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/images/city_doodle.png",
                  color: Theme.of(context).primaryColor)
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 135.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/icons/acs_logo.png",
                                height: ScreenUtil().setWidth(150)),
                            Image.asset(
                              "assets/images/acs_banner.png",
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              height: ScreenUtil().setWidth(85),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FormCard(),
                  SizedBox(height: ScreenUtil().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppButton(
                        text: S.of(context).loginAnonymouslyLabel,
                        onTap: () => authProvider.signInAnonymously(),
                      ),
                      AppButton(
                        colors: [Color(0xFF4DB4E4), Color(0xFF292562)],
                        text: S.of(context).loginLabel,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text(S.of(context).socialLoginLabel,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500)),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        color: Color(0xFF3B5998),
                        iconData: CustomIcons.facebook,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        color: Color(0xFF1A1A1A),
                        iconData: CustomIcons.google,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        S.of(context).newUserLabel + " ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(S.of(context).signUpLabel,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
