import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:preferences/preference_service.dart';

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
      this.defaultRelevance,
      AuthProvider authProvider})
      : _enabled = filterEnabled ?? PrefService.get('relevance_filter') ?? true,
        _relevantNodes = defaultRelevance,
        authProvider = authProvider ?? AuthProvider() {
    if (defaultRelevance != null && !defaultRelevance.contains('All')) {
      if (defaultDegree == null) {
        throw ArgumentError(
            'If the relevance is not null, the degree cannot be null.');
      }
    }
  }

  final Firestore _db = Firestore.instance;
  Filter _relevanceFilter; // filter cache

  /// Whether this is the global filter instance and should update shared preferences
  final bool global;

  final String defaultDegree;

  bool _enabled;
  List<String> _relevantNodes;
  final List<String> defaultRelevance;

  final AuthProvider authProvider;

  void resetFilter() {
    _relevanceFilter = null;

    _relevantNodes = null;
    if (global) {
      setFilterNodes(null);
      PrefService.setBool('relevance_filter', true);
    }
  }
  Future<void> setFilterNodes(List<String> nodes) async{
    try {
      final DocumentReference doc = _db.collection('users').document(authProvider.uid);
      await doc.updateData({'filter_nodes': nodes});
    } catch (e) {
      print(e);
    }
  }
  Future<List<String>> getFilterNodes(String nodes) async{
    try {
      final DocumentReference doc = _db.collection('users').document(authProvider.uid);
      final DocumentSnapshot snap = await doc.get();
      final filterNodes =  List<String>.from(snap['filter_nodes'] ?? []);
      return filterNodes;
    } catch (e) {
      print(e);
      return null;
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
      setFilterNodes(_relevanceFilter.relevantNodes);
    }
    notifyListeners();
  }

  bool get filterEnabled => _enabled;

  Filter get cachedFilter => _relevanceFilter?.clone();

  Future<Filter> fetchFilter({BuildContext context}) async {
    if (_relevanceFilter != null) {
      return cachedFilter;
    }

    try {
      final col = _db.collection('filters');
      final ref = col.document('relevance');
      final doc = await ref.get();
      final data = doc.data;
      final DocumentReference docUsers = _db.collection('users').document(authProvider.uid);
      final DocumentSnapshot snapUsers = await docUsers.get();

      final levelNames = <Map<String, String>>[];
      // Cast from List<dynamic> to List<Map<String, String>>
      final names = data['levelNames'];
      for (final name in names) {
        levelNames.add(Map<String, String>.from(name));
      }

      final root = data['root'];
      _relevanceFilter = Filter(
        localizedLevelNames: levelNames,
        root: FilterNodeExtension.fromMap(root, 'All'),
      );

      //Set the default relevance, if provided
      if (defaultRelevance != null) {
        for (final node in defaultRelevance) {
          _relevanceFilter.setRelevantUpToRoot(node, defaultDegree);
        }
        _relevantNodes = _relevanceFilter.relevantNodes;
      }

      // Check if there is an existing setting already
      if (global) {
        _relevantNodes = List<String>.from(snapUsers['filter_nodes']);
        _relevanceFilter.setRelevantNodes(_relevantNodes);
        notifyListeners();
      }

      if(_relevantNodes == null){
        // No previous setting or defaults => set the user's group
        if (authProvider.isAuthenticatedFromCache) {
          final user = await authProvider.currentUser;
          // Try to set the default from the user data
          if (user != null && user.classes != null) {
            _relevanceFilter.setRelevantNodes(user.classes);
            notifyListeners();
          }
        }
      }

      return cachedFilter;
    } catch (e, _) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
