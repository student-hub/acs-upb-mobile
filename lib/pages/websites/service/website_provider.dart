import 'package:acs_upb_mobile/pages/websites/model/website.dart';
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

  Stream<List<Website>> getWebsites() {
    try {
      var snaps = _db.collection('websites').snapshots();
      snaps.handleError((e) {
        print(e);
        return Stream.empty();
      });

      return snaps.map<List<Website>>((list) => list.documents
          .map<Website>((doc) => WebsiteFromSnap.fromSnap(doc))
          .toList());
    } catch (e) {
      return Stream.empty();
    }
  }
}
