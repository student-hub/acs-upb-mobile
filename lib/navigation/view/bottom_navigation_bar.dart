import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/home/profile_card.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
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
        ? WebNavigationBar(
            tabs: tabs,
            bucket: bucket,
            tabIndex: widget.tabIndex,
          )
        : MobileNavigationBar(
            tabs: tabs,
            tabController: tabController,
            bucket: bucket,
            tabIndex: widget.tabIndex,
          );
  }
}

class MobileNavigationBar extends StatefulWidget {
  const MobileNavigationBar(
      {Key key, this.tabs, this.tabController, this.bucket, this.tabIndex})
      : super(key: key);

  final List<Widget> tabs;
  final TabController tabController;
  final PageStorageBucket bucket;
  final int tabIndex;

  @override
  _MobileNavigationBarState createState() => _MobileNavigationBarState();
}

class _MobileNavigationBarState extends State<MobileNavigationBar> {
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
            height: 52,
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
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: currentTab == 1
                            ? const Icon(Icons.calendar_today)
                            : const Icon(Icons.calendar_today_outlined),
                        text: S.current.navigationTimetable,
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: const Icon(FeatherIcons.globe),
                        text: S.current.navigationPortal,
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: currentTab == 3
                            ? const Icon(Icons.people)
                            : const Icon(Icons.people_outlined),
                        text: S.current.navigationPeople,
                        iconMargin: EdgeInsets.zero,
                      ),
                    ],
                    labelColor: Theme.of(context).accentColor,
                    labelPadding: const EdgeInsets.only(top: 4),
                    unselectedLabelColor:
                        Theme.of(context).unselectedWidgetColor,
                    indicatorColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebNavigationBar extends StatefulWidget {
  const WebNavigationBar({Key key, this.tabs, this.bucket, this.tabIndex})
      : super(key: key);

  final List<Widget> tabs;
  final PageStorageBucket bucket;
  final int tabIndex;

  @override
  _WebNavigationBarState createState() => _WebNavigationBarState();
}

class _WebNavigationBarState extends State<WebNavigationBar> {
  int currentTab = 0;
  bool _extended = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
            selectedIndex: currentTab,
            onDestinationSelected: (int index) {
              setState(() {
                currentTab = index;
              });
            },
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

class DummySearchBar extends StatefulWidget {
  const DummySearchBar({Key key, this.leading}) : super(key: key);

  final Widget leading;

  @override
  _DummySearchBarState createState() => _DummySearchBarState();
}

class _DummySearchBarState extends State<DummySearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withAlpha(60),
      child: Row(
        children: [
          widget.leading ?? const SizedBox.shrink(),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              // TODO(RazvanRotaru): Wrap in Button and goto /home
              child: UniBanner(),
            ),
            width: 500,
          ),
          const Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 200,
                    top: 15,
                    bottom: 15,
                    right: 15,
                  ),
                  child: Text('THIS IS A SEARCHBAR'),
                ),
              ),
            ),
            flex: 3,
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: PopupMenuButton(
                color: Theme.of(context).backgroundColor,
                offset: const Offset(-5, 45),
                tooltip: 'Profile Menu',
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    'assets/illustrations/undraw_profile_pic.png',
                  ),
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry<void>>[
                    const PopupMenuItem(
                      enabled: false,
                      child: ProfileCard(
                        isMenu: true,
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      child: IconText(
                        icon: Icons.settings,
                        text: 'Settings',
                        onTap: () {
                          // TODO(RazvanRotaru): add SettingsPage view
                          print('Goto Settings');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: IconText(
                        icon: Icons.logout,
                        text: 'Log Out',
                        onTap: () {
                          Utils.signOut(context);
                        },
                      ),
                    )
                  ];
                },
              ),
            ),
            width: 100,
          )
        ],
      ),
    );
  }
}
