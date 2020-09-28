import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffoldAction {
  AppScaffoldAction(
      {this.icon,
      this.route,
      this.onPressed,
      this.tooltip,
      this.text,
      this.items});

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
}

class AppScaffold extends StatelessWidget {
  AppScaffold({
    this.body,
    this.title,
    List<AppScaffoldAction> actions,
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

  Widget _widgetFromAction(AppScaffoldAction action,
      {@required bool enableContent, @required BuildContext context}) {
    if (action == null) {
      return null;
    }

    final void Function() onPressed =
        !enableContent || (action?.onPressed == null && action?.route == null)
            ? null
            : action?.onPressed ??
                () => Navigator.pushNamed(context, action?.route);

    return action?.items != null
        ? PopupMenuButton<String>(
            icon: Icon(action.icon),
            tooltip: action.tooltip ?? action.text,
            onSelected: (selected) => action.items[selected](),
            itemBuilder: (BuildContext context) {
              return action.items.keys
                  .map((option) => PopupMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList();
            },
            offset: const Offset(0, 100),
          )
        : Tooltip(
            message: action?.tooltip ?? action?.text ?? '',
            child: action?.text != null
                ? ButtonTheme(
                    minWidth: 8,
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        action.text,
                        style: const TextStyle().apply(
                            color: Theme.of(context).primaryIconTheme.color),
                      ),
                      onPressed: onPressed,
                    ),
                  )
                : IconButton(
                    icon: Icon(action?.icon),
                    onPressed: onPressed,
                  ),
          );
  }

  Widget _underConstructionPage({@required BuildContext context}) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            const Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    image: AssetImage(
                        'assets/illustrations/undraw_under_construction.png')),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(S.of(context).messageUnderConstruction,
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      );

  Widget _needsAuthenticationPage({@required BuildContext context}) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            const Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    image:
                        AssetImage('assets/illustrations/undraw_sign_in.png')),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        S.of(context).warningAuthenticationNeeded,
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Utils.signOut(context);
                    },
                    child: Text(S.of(context).actionLogIn,
                        style: Theme.of(context)
                            .accentTextTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isAuthenticated =
        authProvider.isAuthenticatedFromCache && !authProvider.isAnonymous;
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
            ? body ?? _underConstructionPage(context: context)
            : _needsAuthenticationPage(context: context),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: title,
            centerTitle: true,
            toolbarOpacity: 0.8,
            leading: _widgetFromAction(leading,
                enableContent: enableContent, context: context),
            actions: actions
                .map((action) => _widgetFromAction(action,
                    enableContent: enableContent, context: context))
                .toList(),
          ),
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
