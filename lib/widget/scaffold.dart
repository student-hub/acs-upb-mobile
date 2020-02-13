import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widget/drawer.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  AppScaffold({this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: AppBar(
        title: Text(title),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: S.of(context).drawerTooltip,
          );
        }),
      ),
      drawer: AppDrawer(),
    );
  }
}
