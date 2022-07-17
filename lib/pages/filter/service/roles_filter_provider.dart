import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/filter.dart';

extension FilterNodeExtension on FilterNode {
  static FilterNode fromMap(
      final Map<String, dynamic> map, final String parentName) {
    final children = <FilterNode>[];

    final sortedKeys = map.keys.toList()..sort();
    for (final key in sortedKeys) {
      children.add(FilterNodeExtension.fromMap(map[key], key));
    }

    return FilterNode(name: parentName, children: children);
  }
}

class RolesFilterProvider with ChangeNotifier {
  Filter _rolesFilter;

  Future<Filter> fetchRolesFilter() async {
    try {
      final filters = FirebaseFirestore.instance.collection('filters');
      final rolesDoc = filters.doc('roles');
      final rolesData = (await rolesDoc.get()).data();

      final levelNames = <Map<String, String>>[];
      final names = rolesData['levelNames'];
      for (final name in names) {
        levelNames.add(Map<String, String>.from(name));
      }

      final localizations = <String, Map<String, String>>{};
      final localizationsData = rolesData['localizations'];
      localizationsData.forEach((final String key, final dynamic value) {
        localizations[key] = Map<String, String>.from(value);
      });

      final root = rolesData['root'];
      _rolesFilter = Filter(
        localizations: localizations,
        localizedLevelNames: levelNames,
        root: FilterNodeExtension.fromMap(root, 'All'),
      );

      notifyListeners();
      return _rolesFilter;
    } catch (e, _) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}
