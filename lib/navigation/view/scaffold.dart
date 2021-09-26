import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/navigation/view/action_bar.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/error_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffoldAction {
  AppScaffoldAction({
    this.icon,
    this.route,
    this.onPressed,
    this.tooltip,
    this.text,
    this.items,
    bool disabled,
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

  Widget toWidget(
      {@required bool enableContent, @required BuildContext context}) {
    final void Function() onPressed =
        !enableContent || (this.onPressed == null && route == null)
            ? null
            : this.onPressed ?? () => AppNavigator.pushNamed(context, route);

    final icon = disabled
        ? Icon(this.icon ?? Icons.menu_outlined,
            color: Theme.of(context).disabledColor)
        : Icon(this.icon);

    return items != null
        ? PopupMenuButton<String>(
            icon: icon,
            tooltip: tooltip ?? text,
            onSelected: (selected) => items[selected](),
            itemBuilder: (BuildContext context) {
              return items.keys
                  .map((option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList();
            },
          )
        : Tooltip(
            message: tooltip ?? text ?? '',
            child: text != null
                ? ButtonTheme(
                    minWidth: 10,
                    child: TextButton(
                      child: Text(
                        text,
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

  /// Wrap simple action button to enable hover and splash effects
  AspectRatio toMaterialActionButton(
      {@required bool enableContent, @required BuildContext context}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.none,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.12),
            hoverColor: Theme.of(context).primaryColor.withOpacity(0.04),
          ),
          child: toWidget(enableContent: enableContent, context: context),
        ),
      ),
    );
  }

  /// Build an action bar button this AppScaffoldAction
  Widget toActionBarButton(
      {@required bool enableContent, @required BuildContext context}) {
    final void Function() onPressed =
        !enableContent || (this.onPressed == null && route == null)
            ? null
            : this.onPressed ?? () => Navigator.pushNamed(context, route);

    final icon = disabled
        ? Icon(this.icon ?? Icons.menu_outlined,
            color: Theme.of(context).disabledColor)
        : Icon(this.icon);

    final child = items != null
        ? PopupMenuButton<String>(
            child: TextButton.icon(
              icon: icon,
              label: Text(tooltip ?? text),
              onPressed: () => {},
            ),
            tooltip: tooltip ?? text,
            onSelected: (selected) => items[selected](),
            itemBuilder: (BuildContext context) {
              return items.keys
                  .map((option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList();
            },
          )
        : TextButton.icon(
            label: Text(text ?? tooltip ?? ''),
            icon: icon,
            onPressed: onPressed,
          );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            border: Border.all(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  AppScaffold({
    this.body,
    this.title,
    List<AppScaffoldAction> actions,
    this.floatingActionButton,
    this.leading,
    this.needsToBeAuthenticated = false,
    this.onWeb = false,
    this.maxBodyWidth = 960,
  }) : actions = actions ?? [];

  final Widget body;
  final Widget title;
  final Widget floatingActionButton;
  final List<AppScaffoldAction> actions;
  final AppScaffoldAction leading;
  final bool needsToBeAuthenticated;
  final bool onWeb;
  final double maxBodyWidth;

  @override
  Widget build(BuildContext context) {
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
            ? buildBody(context, enableContent: enableContent) ??
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
        appBar: (!kIsWeb || onWeb)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: AppBar(
                  title: title,
                  centerTitle: true,
                  toolbarOpacity: 0.8,
                  leading: leading?.toWidget(
                      enableContent: enableContent, context: context),
                  actions: actions
                      .map(
                        (action) => action?.toWidget(
                            enableContent: enableContent, context: context),
                      )
                      .toList(),
                ),
              )
            : const PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: SizedBox.shrink(),
              ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  /// Build content body based on platform.
  /// On web, there are action buttons on the right side.
  Widget buildBody(BuildContext context, {bool enableContent = false}) {
    // check if on web to avoid building action button twice in mobile
    final List<AppScaffoldAction> actionsList = kIsWeb
        ? ([leading] + actions).where((element) => element != null).toList()
        : List.empty();

    return !kIsWeb
        ? body
        : Column(
            children: [
              if (actionsList.isNotEmpty)
                ActionBar(actionsList
                    .map((e) => e?.toActionBarButton(
                        enableContent: enableContent, context: context))
                    .where((element) => element != null)
                    .toList()),
              Expanded(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxBodyWidth),
                        child: body)),
              ),
            ],
          );
  }
}
