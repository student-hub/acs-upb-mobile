import 'package:acs_upb_mobile/generated/l10n.dart';
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
  @override
  Widget build(BuildContext context) {
    var currentTab = [
      HomePage(),
      TimetablePage(),
      PortalPage(),
      AppScaffold(title: S.of(context).navigationMap), // TODO: Map
      ProfilePage(),
    ];

    var provider = Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      body: currentTab[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(S.of(context).navigationHome),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text(S.of(context).navigationTimetable),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            title: Text(S.of(context).navigationPortal),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text(S.of(context).navigationMap),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(S.of(context).navigationProfile),
          ),
        ],
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
