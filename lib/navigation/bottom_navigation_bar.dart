import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int tabIndex;

  AppBottomNavigationBar({this.tabIndex = 0});

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  var tabs;
  TabController tabController;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabs = [
      HomePage(key: PageStorageKey('Home'), tabController: tabController),
      TimetablePage(),  // Cannot preserve state with PageStorageKey
      PortalPage(key: PageStorageKey('Portal')),
      PeoplePage(key: PageStorageKey('People')),
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
        bottomNavigationBar: SizedBox(
          height: 45,
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: S.of(context).navigationHome,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.calendar_today_rounded),
                text: S.of(context).navigationTimetable,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.public),
                text: S.of(context).navigationPortal,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.people),
                text: S.of(context).navigationPeople,
                iconMargin: EdgeInsets.all(0),
              ),
            ],
            labelColor: Theme.of(context).accentColor,
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            indicatorColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
