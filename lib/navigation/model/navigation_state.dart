import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:flutter/cupertino.dart';

class NavigationStateProvider extends ChangeNotifier {
  final _NavigationState _state = _NavigationState();

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
    _state
      ..path = path
      ..view = null;
    notifyListeners();
  }

  bool get isDrawerExtended => _state.isDrawerExtended;

  set isDrawerExtended(bool value) {
    _state.isDrawerExtended = value;
    notifyListeners();
  }

  void toggleDrawer() {
    _state.isDrawerExtended = !_state.isDrawerExtended;
    notifyListeners();
  }

  Widget get customView => _state.view;

  set customView(Widget view) {
    _state.view = view;
    notifyListeners();
  }

  void reset() {
    _state
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
    isDrawerExtended = false;
    view = null;
  }

  bool isInitialized;
  RoutePath path;

  int selectedTab;
  bool isDrawerExtended;

  Widget view;

  @override
  String toString() {
    return '_NavigationState{path: $path, selectedTab: $selectedTab, isDrawerExtended: $isDrawerExtended, view: $view}';
  }
}
