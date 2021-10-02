import 'dart:collection';

import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/cupertino.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isInitialized = false;
  RoutePath _path;
  final _previousPaths = Queue<RoutePath>();

  int _selectedTab = 0;
  bool isDrawerExtended = false;

  Widget _view;

  int get selectedTab => _selectedTab;

  set selectedTab(int tab) {
    _selectedTab = tab;
    _view = null;

    switch (tab) {
      case 0:
        _path = PathFactory.from(Uri.parse(HomePage.routeName));
        break;
      case 1:
        _path = PathFactory.from(Uri.parse(TimetablePage.routeName));
        break;
      case 2:
        _path = PathFactory.from(Uri.parse(PortalPage.routeName));
        break;
      case 3:
        _path = PathFactory.from(Uri.parse(PeoplePage.routeName));
        break;
    }

    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  RoutePath get path => _path;

  set path(RoutePath path) {
    _previousPaths.addFirst(_path);
    _path = path;
    _view = null;

    switch (path.runtimeType) {
      case HomePath:
        _selectedTab = 0;
        break;
      case TimetablePath:
        _selectedTab = 1;
        break;
      case PortalPath:
        _selectedTab = 2;
        break;
      case PeoplePath:
        _selectedTab = 3;
        break;
      case LoginPath:
        isDrawerExtended = false;
        break;
    }

    notifyListeners();
  }

  RoutePath get previousPath => _previousPaths.first;

  void back() {
    if (_previousPaths.isEmpty) reset();

    _view = null;
    _path = _previousPaths.removeFirst();
    notifyListeners();
  }

  void toggleDrawer() {
    isDrawerExtended = !isDrawerExtended;
  }

  Widget get customView => _view;

  set customView(Widget view) {
    _view = view;
    notifyListeners();
  }

  void reset() {
    _path = HomePath();
    _view = null;
  }

  @override
  String toString() {
    return 'NavigationStateProvider{_path: $_path, _selectedTab: $_selectedTab, _view: $_view}';
  }
}
