import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

extension FilterNodeExtension on FilterNode {
  static FilterNode fromMap(Map<String, dynamic> map, String parentName) {
    List<FilterNode> children = [];

    map.forEach(
        (key, value) => children.add(FilterNodeExtension.fromMap(value, key)));

    return FilterNode(name: parentName, children: children);
  }
}

class FilterProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  Filter _relevanceFilter;

  Future<Filter> getRelevanceFilter() async {
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

      Map<String, dynamic> root = data['root'];
      _relevanceFilter = Filter(
          localizedLevelNames: levelNames,
          root: FilterNodeExtension.fromMap(root, 'All'));
      return _relevanceFilter;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
