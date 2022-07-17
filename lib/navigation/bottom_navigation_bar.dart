import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../authentication/service/auth_provider.dart';
import '../generated/l10n.dart';
import '../pages/home/home_page.dart';
import '../pages/people/view/people_page.dart';
import '../pages/portal/view/portal_page.dart';
import '../pages/settings/view/source_page.dart';
import '../pages/timetable/view/timetable_page.dart';

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

    // Show "Select sources" page if user has no preference set
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAnonymous) {
      authProvider.currentUser.then((user) {
        if (user?.sources?.isEmpty ?? true) {
          Navigator.of(context).push(MaterialPageRoute<SourcePage>(
              builder: (final context) => SourcePage()));
        }
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
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
                    labelColor: Theme.of(context).primaryColor,
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
