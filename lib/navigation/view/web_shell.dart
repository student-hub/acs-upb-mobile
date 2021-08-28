import 'package:acs_upb_mobile/navigation/model/navigation_state.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/navigation/service/app_router_delegates.dart';
import 'package:acs_upb_mobile/navigation/view/bottom_navigation_bar.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class WebShell extends StatefulWidget {
  WebShell({Key key, this.navigationState}) : super(key: key);

  final NavigationStateProvider navigationState;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  _WebShellState createState() => _WebShellState();
}

class _WebShellState extends State<WebShell> {
  bool _extended = false;
  InnerRouterDelegate _innerRouterDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  @override
  void initState() {
    super.initState();
    _innerRouterDelegate =
        InnerRouterDelegate(navigationState: widget.navigationState);
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
      widget.navigationState.selectedTab = index;

      switch (index) {
        case 0:
          AppNavigator.pushNamed(context, HomePage.routeName);
          break;
        case 1:
          AppNavigator.pushNamed(context, TimetablePage.routeName);
          break;
        case 2:
          AppNavigator.pushNamed(context, PortalPage.routeName);
          break;
        case 3:
          AppNavigator.pushNamed(context, PeoplePage.routeName);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 100),
        child: DummySearchBar(
          leading: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _extended = !_extended;
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
            selectedIndex: widget.navigationState.selectedTab,
            onDestinationSelected: handleNavigationBar,
            extended: _extended,
            labelType: NavigationRailLabelType.none,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home),
                selectedIcon: const Icon(Icons.home_outlined),
                // TODO(RazvanRotaru): re-enable padding after Flutter2 migration (also works on 1.27+)
                // padding: const EdgeInsets.only(right: 5),
                label: Text(S.current.navigationHome),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.calendar_today),
                selectedIcon: const Icon(Icons.calendar_today_outlined),
                // padding: const EdgeInsets.only(right: 5),
                label: Text(S.current.navigationTimetable),
              ),
              NavigationRailDestination(
                icon: const Icon(FeatherIcons.globe),
                selectedIcon: const Icon(FeatherIcons.globe),
                // padding: const EdgeInsets.only(right: 5),
                label: Text(S.current.navigationPortal),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.people),
                selectedIcon: const Icon(Icons.people_outlined),
                // padding: const EdgeInsets.only(right: 5),
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
            // TODO(WebTeam): Wrap with ConstrainedBox
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
    );
  }
}
