import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

extension FilterNodeExtension on FilterNode {
  static FilterNode fromMap(Map<String, dynamic> map, String parentName) {
    List<FilterNode> children = [];

    var sortedKeys = map.keys.toList()..sort();
    sortedKeys.forEach(
        (key) => children.add(FilterNodeExtension.fromMap(map[key], key)));

    return FilterNode(name: parentName, children: children);
  }
}

class FilterProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  Filter _relevanceFilter;  // filter cache

  void resetFilter() {
    _relevanceFilter = null;

    // Reset filter preference
    PrefService.setStringList('relevant_nodes', null);
  }

  void enableFilter() {
    _relevanceFilter = null;
    PrefService.setBool('relevance_filter', true);
    notifyListeners();
  }

  void disableFilter() {
    _relevanceFilter = null;
    PrefService.setBool('relevance_filter', false);
    notifyListeners();
  }

  bool get filterEnabled => PrefService.get('relevance_filter');

  Future<Filter> fetchFilter(BuildContext context) async {
    if (_relevanceFilter != null) {
      return _relevanceFilter;
    }

    try {
      var col = _db.collection('filters');
      var ref = col.document('relevance');
      var doc = await ref.get();
      var data = doc.data;

      List<Map<String, String>> levelNames = [];
      // Cast from List<dynamic> to List<Map<String, String>>
      List names = data['levelNames'];
      names.forEach(
          (element) => levelNames.add(Map<String, String>.from(element)));

      // Check if there is an existing setting already
      List<String> relevantNodes = PrefService.get('relevant_nodes') == null
          ? null
          : List<String>.from(PrefService.get('relevant_nodes'));

      Map<String, dynamic> root = data['root'];
      _relevanceFilter = Filter(
          localizedLevelNames: levelNames,
          root: FilterNodeExtension.fromMap(root, 'All'),
          listener: () {
            PrefService.setStringList(
                'relevant_nodes', _relevanceFilter.relevantNodes);
            notifyListeners();
          });

      // No previous setting
      if (relevantNodes == null) {
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isAuthenticatedFromCache) {
          User user = await authProvider.currentUser;
          // Try to set the default as the user's group
          if (user != null) {
            _relevanceFilter.setRelevantUpToRoot(user.group);
            relevantNodes = PrefService.get('relevant_nodes');
          }
        }
      }

      if (relevantNodes != null) {
        _relevanceFilter.setRelevantNodes(relevantNodes);
      }

      return _relevanceFilter;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
