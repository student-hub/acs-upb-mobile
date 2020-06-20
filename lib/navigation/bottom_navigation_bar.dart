import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/profile/profile_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBottomNavigationBar extends StatefulWidget {
  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  var tabs;

  @override
  Widget build(BuildContext context) {
    if (tabs == null) {
      tabs = [
        HomePage(),
        ChangeNotifierProvider(
            create: (_) => ClassProvider(), child: TimetablePage()),
        PortalPage(),
        AppScaffold(title: S.of(context).navigationMap), // TODO: Map
        ProfilePage(),
      ];
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: TabBarView(children: tabs),
        bottomNavigationBar: SizedBox(
          height: 45,
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: S.of(context).navigationHome,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: S.of(context).navigationTimetable,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.public),
                text: S.of(context).navigationPortal,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.map),
                text: S.of(context).navigationMap,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.person),
                text: S.of(context).navigationProfile,
                iconMargin: EdgeInsets.all(0),
              ),
            ],
            labelColor: Theme.of(context).accentColor,
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
          ),
        ),
      ),
    );
  }
}
