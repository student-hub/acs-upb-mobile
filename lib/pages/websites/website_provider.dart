import 'package:acs_upb_mobile/pages/websites/website.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension WebsiteFromSnap on Website {
  static Website fromSnap(DocumentSnapshot snap) {
    return Website(
      category: snap.data['category'],
      iconPath: snap.data['icon'],
      label: snap.data['label'],
      link: snap.data['link'],
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
