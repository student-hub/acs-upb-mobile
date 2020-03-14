import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/profile/profile_page.dart';
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
      AppScaffold(title: S.of(context).navigationTimetable), // TODO: Timetable
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
            icon: new Icon(Icons.home),
            title: new Text(S.of(context).navigationHome),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text(S.of(context).navigationTimetable),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.public),
            title: new Text(S.of(context).navigationPortal),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text(S.of(context).navigationMap),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text(S.of(context).navigationProfile),
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
