import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication/service/auth_provider.dart';
import '../generated/l10n.dart';
import '../resources/utils.dart';
import 'error_page.dart';

class AppScaffoldAction {
  AppScaffoldAction({
    this.icon,
    this.route,
    this.onPressed,
    this.tooltip,
    this.text,
    this.items,
    final bool disabled,
  }) : disabled = disabled ?? false;

  // Icon for the action button
  final IconData icon;

  // Route to push when the action button is pressed
  final String route;

  // Action that happens when the button is pressed. This overrides [route].
  final void Function() onPressed;

  // Action button tooltip text
  final String tooltip;

  // Action text. This overrides [icon].
  final String text;

  // Option-action map that should be specified if a popup menu is needed. It
  // overrides [route].
  final Map<String, void Function()> items;

  // Whether the icon color should be disabled.
  final bool disabled;
}

class AppScaffold extends StatelessWidget {
  AppScaffold({
    this.body,
    this.title,
    final List<AppScaffoldAction> actions,
    this.floatingActionButton,
    this.leading,
    this.needsToBeAuthenticated = false,
  }) : actions = actions ?? [];

  final Widget body;
  final Widget title;
  final Widget floatingActionButton;
  final List<AppScaffoldAction> actions;
  final AppScaffoldAction leading;
  final bool needsToBeAuthenticated;

  Widget _widgetFromAction(final AppScaffoldAction action,
      {@required final bool enableContent, @required final BuildContext context}) {
    if (action == null) {
      return null;
    }

    final void Function() onPressed =
        !enableContent || (action?.onPressed == null && action?.route == null)
            ? null
            : action?.onPressed ??
                () => Navigator.pushNamed(context, action?.route);

    final icon = action.disabled
        ? Icon(action.icon ?? Icons.menu_outlined,
            color: Theme.of(context).disabledColor)
        : Icon(action.icon);

    return action?.items != null
        ? PopupMenuButton<String>(
            icon: icon,
            tooltip: action.tooltip ?? action.text,
            onSelected: (final selected) => action.items[selected](),
            itemBuilder: (final BuildContext context) {
              return action.items.keys
                  .map((final option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList();
            },
          )
        : Tooltip(
            message: action?.tooltip ?? action?.text ?? '',
            child: action?.text != null
                ? ButtonTheme(
                    minWidth: 10,
                    child: TextButton(
                      child: Text(
                        action.text,
                        style: const TextStyle().apply(
                            color: Theme.of(context).primaryIconTheme.color),
                      ),
                      onPressed: onPressed,
                    ),
                  )
                : IconButton(
                    icon: icon,
                    onPressed: onPressed,
                  ),
          );
  }

  @override
  Widget build(final BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isAuthenticated =
        authProvider.isAuthenticated && !authProvider.isAnonymous;
    final bool enableContent = !needsToBeAuthenticated || isAuthenticated;

    return GestureDetector(
      onTap: () {
        // Remove current focus on tap
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: enableContent
            ? body ??
                ErrorPage(
                  imgPath: 'assets/illustrations/undraw_under_construction.png',
                  errorMessage: S.current.messageUnderConstruction,
                )
            : ErrorPage(
                imgPath: 'assets/illustrations/undraw_sign_in.png',
                info: [TextSpan(text: S.current.warningAuthenticationNeeded)],
                actionText: S.current.actionLogIn,
                actionOnTap: () => Utils.signOut(context),
              ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: title,
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            toolbarOpacity: 0.8,
            leading: _widgetFromAction(leading,
                enableContent: enableContent, context: context),
            actions: actions
                .map((final action) => _widgetFromAction(action,
                    enableContent: enableContent, context: context))
                .toList(),
          ),
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
