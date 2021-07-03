import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({this.tabIndex = 0});

  final int tabIndex;

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  List<Widget> tabs;
  TabController tabController;
  final PageStorageBucket bucket = PageStorageBucket();
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });
    tabs = [
      HomePage(key: const PageStorageKey('Home'), tabController: tabController),
      const TimetablePage(), // Cannot preserve state with PageStorageKey
      const PortalPage(key: PageStorageKey('Portal')),
      const PeoplePage(key: PageStorageKey('People')),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? WebLayout(
            tabs: tabs,
            bucket: bucket,
            tabIndex: widget.tabIndex,
          )
        : MobileLayout(
            tabs: tabs,
            tabController: tabController,
            bucket: bucket,
            tabIndex: widget.tabIndex,
          );
  }
}

class MobileLayout extends StatefulWidget {
  const MobileLayout(
      {Key key, this.tabs, this.tabController, this.bucket, this.tabIndex})
      : super(key: key);

  final List<Widget> tabs;
  final TabController tabController;
  final PageStorageBucket bucket;
  final int tabIndex;

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        body: PageStorage(
          child: TabBarView(
              controller: widget.tabController, children: widget.tabs),
          bucket: widget.bucket,
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 50,
            child: Column(
              children: [
                const Divider(indent: 0, endIndent: 0, height: 1),
                Expanded(
                  child: TabBar(
                    controller: widget.tabController,
                    tabs: [
                      Tab(
                        icon: currentTab == 0
                            ? const Icon(Icons.home)
                            : const Icon(Icons.home_outlined),
                        text: S.current.navigationHome,
                        iconMargin: const EdgeInsets.only(top: 5),
                      ),
                      Tab(
                        icon: currentTab == 1
                            ? const Icon(Icons.calendar_today)
                            : const Icon(Icons.calendar_today_outlined),
                        text: S.current.navigationTimetable,
                        iconMargin: const EdgeInsets.only(top: 5),
                      ),
                      Tab(
                        icon: const Icon(FeatherIcons.globe),
                        text: S.current.navigationPortal,
                        iconMargin: const EdgeInsets.only(top: 5),
                      ),
                      Tab(
                        icon: currentTab == 3
                            ? const Icon(Icons.people)
                            : const Icon(Icons.people_outlined),
                        text: S.current.navigationPeople,
                        iconMargin: const EdgeInsets.only(top: 5),
                      ),
                    ],
                    labelColor: Theme.of(context).accentColor,
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor:
                        Theme.of(context).unselectedWidgetColor,
                    indicatorColor: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebLayout extends StatefulWidget {
  const WebLayout({Key key, this.tabs, this.bucket, this.tabIndex})
      : super(key: key);

  final List<Widget> tabs;
  final PageStorageBucket bucket;
  final int tabIndex;

  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 100),
        child: SearchBarDemoHome(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: NavigationRail(
              selectedIndex: currentTab,
              onDestinationSelected: (int index) {
                setState(() {
                  currentTab = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home),
                  selectedIcon: const Icon(Icons.home_outlined),
                  padding: const EdgeInsets.only(right: 5),
                  label: Text(S.current.navigationHome),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.calendar_today),
                  selectedIcon: const Icon(Icons.calendar_today_outlined),
                  padding: const EdgeInsets.only(right: 5),
                  label: Text(S.current.navigationTimetable),
                ),
                NavigationRailDestination(
                  icon: const Icon(FeatherIcons.globe),
                  selectedIcon: const Icon(FeatherIcons.globe),
                  padding: const EdgeInsets.only(right: 5),
                  label: Text(S.current.navigationPortal),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.people),
                  selectedIcon: const Icon(Icons.people_outlined),
                  padding: const EdgeInsets.only(right: 5),
                  label: Text(S.current.navigationPeople),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            flex: 5,
            child: PageStorage(
              child: widget.tabs[currentTab],
              bucket: widget.bucket,
            ),
          ),
        ],
      ),
    );
  }
}


class SearchBarDemoHome extends StatefulWidget {
  @override
  _SearchBarDemoHomeState createState() => _SearchBarDemoHomeState();
}

class _SearchBarDemoHomeState extends State<SearchBarDemoHome> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      child: Row(
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: UniBanner(),
            ),
            width: 500,
          ),
          const Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: Card(child: Padding(
                  padding: EdgeInsets.only(left: 200, top: 15, bottom: 15, right: 15),
                  child: Text('THIS IS A SEARCHBAR, OK?'),
                ))),
            flex: 3,
          ),
          const SizedBox(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  'assets/illustrations/undraw_profile_pic.png',
                ), //TODO(RazvanRotaru): move profile here
            ),
            width: 100,
          )
        ],
      ),
    );
  }
}