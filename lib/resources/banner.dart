import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UniBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/acs_logo.png',
                  height: 80,
                ),
                Image.asset(
                  S.current.fileAcsBanner,
                  color: Theme.of(context).textTheme.headline6.color,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      );
}
