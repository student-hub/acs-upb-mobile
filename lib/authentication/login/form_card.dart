import 'package:acs_upb_mobile/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FormCard extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  FormCard(
      {TextEditingController emailController,
      TextEditingController passwordController})
      : this.emailController = emailController ?? TextEditingController(),
        this.passwordController = passwordController ?? TextEditingController();

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  Future<bool> canSignInWithPassword;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    canSignInWithPassword = Future<bool>(() => null);
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).loginLabel,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(45),
                    fontWeight: FontWeight.bold,
                    letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Text(S.of(context).emailLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(26))),
            TextField(
              controller: widget.emailController,
              onChanged: (email) => setState(() {
                canSignInWithPassword =
                    authProvider.canSignInWithPassword(email: email);
              }),
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(passwordFocusNode),
              decoration: InputDecoration(
                hintText: S.of(context).emailLabel.toLowerCase(),
                hintStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
                suffixIcon: FutureBuilder(
                  future: canSignInWithPassword,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        // Display transparent icon
                        return CustomIcons.empty;
                      } else {
                        return snapshot.data
                            ? CustomIcons.valid
                            : CustomIcons.invalid;
                      }
                    } else {
                      return CustomIcons.empty;
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Text(S.of(context).passwordLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(26))),
            TextField(
              obscureText: true,
              controller: widget.passwordController,
              focusNode: passwordFocusNode,
              onSubmitted: (password) => authProvider.signIn(
                  email: widget.emailController.text, password: password),
              decoration: InputDecoration(
                  hintText: S.of(context).passwordLabel.toLowerCase(),
                  hintStyle: TextStyle(fontSize: ScreenUtil().setSp(22))),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(35),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  S.of(context).recoverPassword,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(28)),
                )
              ],
            ),
            // If the following is missing, the Column overflows for some reason
            Expanded(
              child: SizedBox(
                height: ScreenUtil().setSp(28),
              ),
            )
          ],
        ),
      ),
    );
  }
}
