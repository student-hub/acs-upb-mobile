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
  Filter _relevanceFilter; // filter cache

  /// Whether this is the global filter instance and should update shared preferences
  final bool global;

  final String defaultDegree;

  bool _enabled;
  List<String> _relevantNodes;

  FilterProvider(
      {this.global = false,
      bool filterEnabled,
      this.defaultDegree,
      List<String> defaultRelevance})
      : _enabled = filterEnabled ?? PrefService.get('relevance_filter') ?? true,
        _relevantNodes = defaultRelevance {
    if (defaultRelevance != null) {
      if (this.defaultDegree == null) {
        throw ArgumentError(
            'If the relevance is not null, the degree cannot be null.');
      }
    }
  }

  void resetFilter() {
    _relevanceFilter = null;

    _relevantNodes = null;
    if (global) {
      // Reset defaults
      PrefService.setStringList('relevant_nodes', null);
      PrefService.setBool('relevance_filter', true);
    }
  }

  void enableFilter() {
    _enabled = true;
    if (global) {
      PrefService.setBool('relevance_filter', true);
    }

    notifyListeners();
  }

  void disableFilter() {
    _relevanceFilter = null;

    _enabled = false;
    if (global) {
      PrefService.setBool('relevance_filter', false);
    }

    notifyListeners();
  }

  bool get filterEnabled => _enabled;

  Filter get cachedFilter => _relevanceFilter;

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
      if (global) {
        _relevantNodes = PrefService.get('relevant_nodes') == null
            ? null
            : List<String>.from(PrefService.get('relevant_nodes'));
      }

      Map<String, dynamic> root = data['root'];
      _relevanceFilter = Filter(
          localizedLevelNames: levelNames,
          root: FilterNodeExtension.fromMap(root, 'All'),
          listener: () {
            if (global) {
              PrefService.setStringList(
                  'relevant_nodes', _relevanceFilter.relevantNodes);
            }
            notifyListeners();
          });

      if (_relevantNodes != null && defaultDegree != null) {
        _relevantNodes.forEach((node) =>
            _relevanceFilter.setRelevantUpToRoot(node, defaultDegree));
      } else {
        // No previous setting or defaults => set the user's group
        AuthenticationProvider authProvider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        if (authProvider.isAuthenticatedFromCache) {
          User user = await authProvider.currentUser;
          // Try to set the default from the user data
          if (user != null) {
            _relevanceFilter.setRelevantNodes([
              user.degree,
              user.domain,
              user.year,
              user.series,
              user.group
            ].where((element) => element != null).toList());
          }
        }
      }

      return _relevanceFilter;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
