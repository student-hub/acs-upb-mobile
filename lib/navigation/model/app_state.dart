import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_machine/time_machine.dart';

class AppStateProvider extends ChangeNotifier {
  int _selectedTab = 0;
  String _profileName;
  bool _isInitialized = false;
  bool _isDrawerExtended = false;
  bool _showFaq = false;
  bool _showNewsFeed = false;
  bool _editProfile = false;
  bool _showClasses = false;
  bool _filter = false;

  Set<ClassHeader> _userClasses;
  String _highlightedEventId;

  String _addEventId;
  LocalDateTime _addEventTime;

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

  LocalDateTime get eventTime => _addEventTime;

  set eventTime(LocalDateTime time) {
    _addEventTime = time;
    notifyListeners();
  }

  String get addEventId => _addEventId;

  set addEventId(String id) {
    _addEventId = id;
    notifyListeners();
  }

  String get highlightedEventId => _highlightedEventId;

  set highlightedEventId(String id) {
    _highlightedEventId = id;
    notifyListeners();
  }

  bool get showClasses => _showClasses;

  set showClasses(bool value) {
    _showClasses = value;
    notifyListeners();
  }

  bool get filter => _filter;

  set filter(bool value) {
    _filter = value;
    notifyListeners();
  }

  void resetParams() {
    _profileName = null;
    _showFaq = false;
    _showNewsFeed = false;
    _editProfile = false;
    _userClasses = null;
    _addEventTime = null;
    _addEventId = null;
    _showClasses = false;
    _filter = false;
  }

  @override
  String toString() {
    return 'AppStateProvider{_selectedTab: $_selectedTab, _profileName: $_profileName, _isDrawerExtended: $_isDrawerExtended, _showFaq: $_showFaq, _showNewsFeed: $_showNewsFeed}';
  }
}
