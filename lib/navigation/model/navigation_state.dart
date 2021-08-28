import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:flutter/cupertino.dart';

class NavigationStateProvider extends ChangeNotifier {
  final _NavigationState _state = _NavigationState();

/*
  String get profileName => _state.profileName;

  set profileName(String name) {
    _state.profileName = name;
    notifyListeners();
  }

  String get websiteId => _state.websiteId;

  set websiteId(String id) {
    _state.websiteId = id;
    notifyListeners();
  }

  String get websiteCategory => _state.websiteCategory;

  set websiteCategory(String category) {
    _state.websiteCategory = category;
    notifyListeners();
  }

  String get classId => _state.classId;

  set classId(String id) {
    _state.classId = id;
    notifyListeners();
  }

  String get eventId => _state.eventId;

  set eventId(String id) {
    _state.eventId = id;
    notifyListeners();
  }
*/

  int get selectedTab => _state.selectedTab;

  set selectedTab(int tab) {
    _state.selectedTab = tab;
    notifyListeners();
  }

  bool get isInitialized => _state.isInitialized;

  set isInitialized(bool value) {
    _state.isInitialized = value;
    notifyListeners();
  }

  RoutePath get path => _state.path;

  set path(RoutePath path) {
    _state.path = path;
    notifyListeners();
  }

  bool get isDrawerExtended => _state.isDrawerExtended;

  void toggleDrawer() {
    _state.isDrawerExtended = !_state.isDrawerExtended;
    notifyListeners();
  }

  Widget get customView => _state.view;

  set customView(Widget view) {
    _state.view = customView;
    notifyListeners();
  }

  void reset() {
    _state
      // ..profileName = null
      // ..websiteId = null
      // ..websiteCategory = null
      // ..eventId = null
      // ..classId = null
      ..path = HomePath()
      ..view = null;
  }

  @override
  String toString() {
    return 'NavigationStateProvider{_state: $_state}';
  }
}

class _NavigationState {
  _NavigationState() {
    isInitialized = false;
    path = null;
    selectedTab = 0;
    // profileName = null;
    // websiteId = null;
    isDrawerExtended = false;
    view = null;
    // filter = false;
  }

  bool isInitialized;
  RoutePath path;

  /*
  String profileName;
  String websiteId;
  String websiteCategory;
  String eventId;
  String classId;
  */

  int selectedTab;
  bool isDrawerExtended;

  Widget view;

  @override
  String toString() {
    return '_NavigationState{path: $path, selectedTab: $selectedTab, view: $view}';
  }
}
