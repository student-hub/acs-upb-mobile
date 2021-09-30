import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/service/navigation_provider.dart';
import 'package:acs_upb_mobile/navigation/service/router_delegates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'webpage_header.dart';

class WebShell extends StatefulWidget {
  WebShell({Key key, this.navigationProvider}) : super(key: key);

  final NavigationProvider navigationProvider;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  _WebShellState createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  InnerRouterDelegate _innerRouterDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _innerRouterDelegate =
        InnerRouterDelegate(navigationProvider: widget.navigationProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  void dispose() {
    _innerRouterDelegate.dispose();
    super.dispose();
  }

  void handleNavigationBar(int index) {
    setState(() {
      widget.navigationProvider.selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    _backButtonDispatcher.takePriority();

    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 100),
          child: WebPageHeader(
            height: 60,
            leading: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.navigationProvider.toggleDrawer();
                    });
                  },
                  icon: const Icon(Icons.menu),
                ),
              ),
            ),
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NavigationRail(
              selectedIndex: widget.navigationProvider.selectedTab,
              onDestinationSelected: handleNavigationBar,
              extended: widget.navigationProvider.isDrawerExtended,
              labelType: NavigationRailLabelType.none,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home),
                  selectedIcon: const Icon(Icons.home_outlined),
                  label: Text(S.current.navigationHome),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.calendar_today),
                  selectedIcon: const Icon(Icons.calendar_today_outlined),
                  label: Text(S.current.navigationTimetable),
                ),
                NavigationRailDestination(
                  icon: const Icon(FeatherIcons.globe),
                  selectedIcon: const Icon(FeatherIcons.globe),
                  label: Text(S.current.navigationPortal),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.people),
                  selectedIcon: const Icon(Icons.people_outlined),
                  label: Text(S.current.navigationPeople),
                ),
              ],
            ),
            const VerticalDivider(
              thickness: 1,
              width: 1,
            ),
            Expanded(
              flex: 5,
              child: PageStorage(
                child: Router<dynamic>(
                  routerDelegate: _innerRouterDelegate,
                  backButtonDispatcher: _backButtonDispatcher,
                ),
                bucket: widget.bucket,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
