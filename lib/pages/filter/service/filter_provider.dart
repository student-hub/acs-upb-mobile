import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

extension FilterNodeExtension on FilterNode {
  static FilterNode fromMap(Map<String, dynamic> map, String parentName) {
    final children = <FilterNode>[];

    final sortedKeys = map.keys.toList()..sort();
    for (final key in sortedKeys) {
      children.add(FilterNodeExtension.fromMap(map[key], key));
    }

    return FilterNode(name: parentName, children: children);
  }
}

class FilterProvider with ChangeNotifier {
  FilterProvider(
      {this.global = false,
      bool filterEnabled,
      this.defaultDegree,
      this.defaultRelevance})
      : _enabled =
            filterEnabled ?? PrefService.get('relevance_filter') ?? true {
    if (defaultRelevance != null && !defaultRelevance.contains('All')) {
      if (defaultDegree == null) {
        throw ArgumentError(
            'If the relevance is not null, the degree cannot be null.');
      }
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Filter _relevanceFilter; // filter cache

  /// Whether this is the global filter instance and should update shared preferences
  final bool global;

  final String defaultDegree;

  bool _enabled;
  List<String> _relevantNodes;
  final List<String> defaultRelevance;

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

  void updateFilter(Filter filter) {
    _relevanceFilter = filter;
    if (global) {
      PrefService.setStringList(
          'relevant_nodes', _relevanceFilter.relevantNodes);
    }
    notifyListeners();
  }

  bool get filterEnabled => _enabled;

  Filter get cachedFilter => _relevanceFilter.clone();

  Future<Filter> fetchFilter(BuildContext context) async {
    if (_relevanceFilter != null) {
      return cachedFilter;
    }

    try {
      final col = _db.collection('filters');
      final ref = col.doc('relevance');
      final doc = await ref.get();
      final data = doc.data();

      final levelNames = <Map<String, String>>[];
      // Cast from List<dynamic> to List<Map<String, String>>
      final names = data['levelNames'];
      for (final name in names) {
        levelNames.add(Map<String, String>.from(name));
      }

      // Check if there is an existing setting already
      if (global) {
        _relevantNodes = PrefService.get('relevant_nodes') == null
            ? null
            : List<String>.from(PrefService.get('relevant_nodes'));
      }

      final root = data['root'];
      _relevanceFilter = Filter(
        localizedLevelNames: levelNames,
        root: FilterNodeExtension.fromMap(root, 'All'),
      );

      if (_relevantNodes == null && defaultRelevance != null) {
        _relevantNodes = defaultRelevance;
        for (final node in _relevantNodes) {
          _relevanceFilter.setRelevantUpToRoot(node, defaultDegree);
        }
      } else if (_relevantNodes != null) {
        _relevanceFilter.setRelevantNodes(_relevantNodes);
      } else {
        // No previous setting or defaults => set the user's group
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isAuthenticated) {
          final user = await authProvider.currentUser;
          // Try to set the default from the user data
          if (user != null && user.classes != null) {
            _relevanceFilter.setRelevantNodes(user.classes);
          }
        }
      }

      return cachedFilter;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
