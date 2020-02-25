import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(
                  hintText: S.of(context).emailLabel.toLowerCase(),
                  hintStyle: TextStyle(fontSize: 12.0)),
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
              decoration: InputDecoration(
                  hintText: S.of(context).passwordLabel.toLowerCase(),
                  hintStyle: TextStyle(fontSize: 12.0)),
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
                height: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
