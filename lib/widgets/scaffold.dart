import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget floatingActionButton;

  // Show an action button on the right side of the scaffold bar
  final bool enableMenu;

  // Icon for the action button
  final IconData menuIcon;

  // Route to push when the action button is pressed
  final String menuRoute;

  // Action that happens when the button is pressed. This overrides [menuRoute].
  final Function() menuAction;

  // Action button tooltip text
  final String menuTooltip;

  // Action text. This overrides [menuIcon].
  final String menuText;

  // Option-action map that should be specified if a popup menu is needed. It
  // overrides [menuRoute].
  final Map<String, void Function()> menuItems;

  AppScaffold(
      {this.body,
      this.title,
      this.enableMenu = false,
      this.menuIcon = Icons.settings,
      this.menuText,
      this.menuRoute = Routes.settings,
      this.menuAction,
      this.menuItems,
      this.menuTooltip, // By default, menuText ?? S.of(context).navigationSettings
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    Function() action =
        menuAction ?? () => Navigator.pushNamed(context, menuRoute);

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
          actions: <Widget>[
            enableMenu
                ? Tooltip(
                    message: menuTooltip ??
                        menuText ??
                        S.of(context).navigationSettings,
                    child: menuItems != null
                        ? PopupMenuButton<String>(
                            icon: Icon(menuIcon),
                            onSelected: (selected) => menuItems[selected](),
                            itemBuilder: (BuildContext context) {
                              return menuItems.keys
                                  .map((option) => PopupMenuItem(
                                        value: option,
                                        child: Text(option),
                                      ))
                                  .toList();
                            },
                            offset: Offset(0, 100),
                          )
                        : menuText != null
                            ? FlatButton(
                                child: Text(menuText),
                                onPressed: action,
                              )
                            : IconButton(
                                icon: Icon(menuIcon),
                                onPressed: action,
                              ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
