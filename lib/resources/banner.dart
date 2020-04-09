import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  "assets/icons/acs_logo.png",
                  height: ScreenUtil().setWidth(220),
                ),
                Image.asset(
                  S.of(context).fileAcsBanner,
                  color: Theme.of(context).textTheme.headline6.color,
                  height: ScreenUtil().setWidth(120),
                ),
              ],
            ),
          ),
        ],
      );
}
