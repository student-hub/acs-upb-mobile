import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/error_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'action_sidebar.dart';
import 'app_scaffold_action.dart';

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
    final List<AppScaffoldAction> actionsList =
        kIsWeb ? ([leading] + actions) : List.empty();

    return !kIsWeb
        ? body
        : Stack(
            children: [
              Center(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxBodyWidth),
                      child: body)),
              if (actionsList.isNotEmpty)
                ActionSideBar(actionsList
                    .map((e) => e?.toMaterialActionButton(
                        enableContent: enableContent, context: context))
                    .where((element) => element != null)
                    .toList())
              else
                const SizedBox.shrink(),
            ],
          );
  }
}
