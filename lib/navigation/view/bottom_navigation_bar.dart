import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
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
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        body: PageStorage(
          child: TabBarView(controller: tabController, children: tabs),
          bucket: bucket,
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 52,
            child: Column(
              children: [
                const Divider(indent: 0, endIndent: 0, height: 1),
                Expanded(
                  child: TabBar(
                    controller: tabController,
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
