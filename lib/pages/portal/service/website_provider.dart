import 'dart:async';

import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension WebsiteCategoryExtension on WebsiteCategory {
  static WebsiteCategory fromString(String category) {
    switch (category) {
      case 'learning':
        return WebsiteCategory.learning;
      case 'administrative':
        return WebsiteCategory.administrative;
      case 'association':
        return WebsiteCategory.association;
      case 'resource':
        return WebsiteCategory.resource;
      default:
        return WebsiteCategory.other;
    }
  }
}

extension WebsiteFromSnap on Website {
  static Website fromSnap(DocumentSnapshot snap) {
    return Website(
      category: WebsiteCategoryExtension.fromString(snap.data['category']),
      iconPath: snap.data['icon'],
      label: snap.data['label'],
      link: snap.data['link'],
      infoByLocale: snap.data['info'] == null
          ? {}
          : {
              'en': snap.data['info']['en'],
              'ro': snap.data['info']['ro'],
            },
    );
  }
}

class WebsiteProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Future<List<Website>> getWebsites(Filter filter) async {
    List<String> relevanceStrings = filter.relevantNodes;
    print(relevanceStrings);

    try {
      List<DocumentSnapshot> documents = [];

      // Documents without a 'relevance' field are relevant for everyone
      Query query = _db.collection('websites').where('relevance', isNull: true);
      QuerySnapshot qSnapshot = await query.getDocuments();
      documents.addAll(qSnapshot.documents);

      for (String string in relevanceStrings) {
        Query query = _db
            .collection('websites')
            .where('relevance', arrayContains: string);
        QuerySnapshot qSnapshot = await query.getDocuments();
        documents.addAll(qSnapshot.documents);
      }

      return documents.map((doc) => WebsiteFromSnap.fromSnap(doc)).toList();
    } catch (e) {
      return null;
    }
  }
}
