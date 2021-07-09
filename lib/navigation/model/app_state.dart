import 'package:flutter/cupertino.dart';

class AppStateProvider extends ChangeNotifier {
  int _selectedTab = 0;
  String _profileName;
  bool _isLogged = false;

  String get profileName => _profileName;

  set profileName(String name) {
    _profileName = name;
    notifyListeners();
  }

  int get selectedTab => _selectedTab;

  set selectedTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  bool get isLogged => _isLogged;

  set isLogged(bool logged) {
    _isLogged = logged;
    notifyListeners();
  }
}
