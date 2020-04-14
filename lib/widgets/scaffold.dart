import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffoldAction {
  // Icon for the action button
  final IconData icon;

  // Route to push when the action button is pressed
  final String route;

  // Action that happens when the button is pressed. This overrides [route].
  final Function() onPressed;

  // Action button tooltip text
  final String tooltip;

  // Action text. This overrides [icon].
  final String text;

  // Option-action map that should be specified if a popup menu is needed. It
  // overrides [route].
  final Map<String, void Function()> items;

  AppScaffoldAction(
      {this.icon,
      this.route,
      this.onPressed,
      this.tooltip,
      this.text,
      this.items});
}

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget floatingActionButton;
  final List<AppScaffoldAction> actions;

  AppScaffold(
      {this.body,
      this.title,
      List<AppScaffoldAction> actions,
      this.floatingActionButton})
      : this.actions = actions ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body ??
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
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
          actions: actions.map((action) {
            Function() onPressed = action.onPressed ??
                () => Navigator.pushNamed(context, action.route);

            return Tooltip(
              message: action.tooltip ??
                  action.text ??
                  S.of(context).navigationSettings,
              child: action.items != null
                  ? PopupMenuButton<String>(
                      icon: Icon(action.icon),
                      onSelected: (selected) => action.items[selected](),
                      itemBuilder: (BuildContext context) {
                        return action.items.keys
                            .map((option) => PopupMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList();
                      },
                      offset: Offset(0, 100),
                    )
                  : action.text != null
                      ? FlatButton(
                          child: Text(
                            action.text,
                            style: TextStyle().apply(
                                color:
                                    Theme.of(context).primaryIconTheme.color),
                          ),
                          onPressed: onPressed,
                        )
                      : IconButton(
                          icon: Icon(action.icon),
                          onPressed: onPressed,
                        ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
