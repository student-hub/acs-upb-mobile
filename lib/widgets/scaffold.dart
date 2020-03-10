import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool settingsAction;
  final Widget floatingActionButton;

  AppScaffold(
      {this.body,
      this.title,
      this.settingsAction = true,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: body ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 4,
                  child: Image(
                      image: AssetImage(
                          'assets/illustrations/undraw_under_construction.png')),
                ),
                Expanded(
                  child: Text(S.of(context).messageUnderConstruction,
                      style: Theme.of(context).textTheme.headline6),
                ),
                Expanded(child: Container()),
              ],
            ),
      ),
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
                    child: Tooltip(
                      message: S.of(context).navigationSettings,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.settings);
                        },
                        child: Icon(
                          Icons.settings,
                          size: 26.0,
                        ),
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
