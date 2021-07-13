import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:flutter/cupertino.dart';

class AppStateProvider extends ChangeNotifier {
  int _selectedTab = 0;
  String _profileName;
  bool _isInitialized = false;
  bool _isDrawerExtended = false;
  bool _showFaq = false;
  bool _showNewsFeed = false;
  bool _editProfile = false;

  Set<ClassHeader> _userClasses;

  String get profileName => _profileName;

  set profileName(String name) {
    _profileName = name;
    notifyListeners();
  }

  int get selectedTab => _selectedTab;

  set selectedTab(int tab) {
    _selectedTab = tab;
    resetParams();
    notifyListeners();
  }

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  bool get isDrawerExtended => _isDrawerExtended;

  set isDrawerExtended(bool value) {
    _isDrawerExtended = !_isDrawerExtended;
    notifyListeners();
  }

  bool get showFaq => _showFaq;

  set showFaq(bool value) {
    print('showFaq to $value');
    _showFaq = value;
    notifyListeners();
  }

  bool get showNewsFeed => _showNewsFeed;

  set showNewsFeed(bool value) {
    _showNewsFeed = value;
    notifyListeners();
  }

  bool get editProfile => _editProfile;

  set editProfile(bool value) {
    _editProfile = value;
    notifyListeners();
  }

  Set<ClassHeader> get userClasses => _userClasses;

  set userClasses(Set<ClassHeader> classes) {
    _userClasses = classes;
    notifyListeners();
  }

  void resetParams() {
    _profileName = null;
    _showFaq = false;
    _showNewsFeed = false;
    _editProfile = false;
    _userClasses = null;
  }

  @override
  String toString() {
    return 'AppStateProvider{_selectedTab: $_selectedTab, _profileName: $_profileName, _isDrawerExtended: $_isDrawerExtended, _showFaq: $_showFaq, _showNewsFeed: $_showNewsFeed}';
  }
}
