import 'package:acs_upb_mobile/routes/routes.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool settingsAction;

  AppScaffold({this.body, this.title, this.settingsAction = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text(title),
          centerTitle: true,
          toolbarOpacity: 0.8,
          actions: <Widget>[
            settingsAction
                ? Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.settings);
                      },
                      child: Icon(
                        Icons.settings,
                        size: 26.0,
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
