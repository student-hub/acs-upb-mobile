import 'package:flutter/material.dart';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widget/drawer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).drawerHeaderHome),
        ),
        drawer: AppDrawer(),
        body: Center(child: Text(S.of(context).drawerHeaderHome)));
  }
}