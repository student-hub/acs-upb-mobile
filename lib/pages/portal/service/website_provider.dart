import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

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

extension WebsiteExtension on Website {
  static Website fromSnap(DocumentSnapshot snap) {
    return Website(
      category: WebsiteCategoryExtension.fromString(snap.data['category']),
      iconPath: snap.data['icon'] ?? 'icons/websites/globe.png',
      label: snap.data['label'] ?? 'Website',
      link: snap.data['link'] ?? '',
      infoByLocale: snap.data['info'] == null
          ? {}
          : {
              'en': snap.data['info']['en'],
              'ro': snap.data['info']['ro'],
            },
    );
  }

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {
      'relevance': null // TODO: Make relevance customizable
    };

    if (label != null) data['label'] = label;
    if (category != null) data['category'] = category.toString();
    if (iconPath != null) data['icon'] = iconPath;
    if (link != null) data['link'] = link;
    if (infoByLocale != null) data['info'] = infoByLocale;

    return data;
  }
}

class WebsiteProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Future<List<Website>> getWebsites(Filter filter) async {
    try {
      List<DocumentSnapshot> documents = [];

      if (filter == null) {
        QuerySnapshot qSnapshot =
            await _db.collection('websites').getDocuments();
        documents.addAll(qSnapshot.documents);
      } else {
        // Documents without a 'relevance' field are relevant for everyone
        Query query =
            _db.collection('websites').where('relevance', isNull: true);
        QuerySnapshot qSnapshot = await query.getDocuments();
        documents.addAll(qSnapshot.documents);

        for (String string in filter.relevantNodes) {
          // selected nodes
          Query query = _db
              .collection('websites')
              .where('degree', isEqualTo: filter.baseNode)
              .where('relevance', arrayContains: string);
          QuerySnapshot qSnapshot = await query.getDocuments();
          documents.addAll(qSnapshot.documents);
        }
      }

      // Remove duplicates
      // (a document may result out of more than one query)
      final seenDocumentIds = Set<String>();
      final uniqueDocuments =
          documents.where((doc) => seenDocumentIds.add(doc.documentID));
      return uniqueDocuments
          .map((doc) => WebsiteExtension.fromSnap(doc))
          .toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> addWebsite(Website website, {BuildContext context}) async {
    assert(website.label != null);

    // Sanitize label to obtain document ID
    String id =
        ReCase(website.label.replaceAll(RegExp('[^A-ZĂÂȘȚa-zăâșț0-9 ]'), ''))
            .snakeCase;
    DocumentReference ref = _db.collection('websites').document(id);

    if ((await ref.get()).data != null) {
      print('A website with id $id already exists');
      if (context != null) {
        AppToast.show(S.of(context).warningWebsiteNameExists);
      }
      return false;
    }

    try {
      await ref.setData(website.toData());
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      AppToast.show(e.message); // TODO: Localize message
      return false;
    }
  }
}
