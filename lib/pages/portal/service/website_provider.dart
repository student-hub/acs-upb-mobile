import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
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

extension WebsiteExtension on Website {
  // [ownerUid] should be provided if the website is user-private
  static Website fromSnap(DocumentSnapshot snap, {String ownerUid}) {
    return Website(
      ownerUid: ownerUid ?? snap.data['addedBy'],
      id: snap.documentID,
      isPrivate: ownerUid != null,
      editedBy: List<String>.from(snap.data['editedBy'] ?? []),
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
    Map<String, dynamic> data = {};

    if (!isPrivate) {
      if (ownerUid != null) data['addedBy'] = ownerUid;
      data['editedBy'] = editedBy;
      data['relevance'] = null; // TODO: Make relevance customizable
    }

    if (label != null) data['label'] = label;
    if (category != null)
      data['category'] = category.toString().split('.').last;
    if (iconPath != null) data['icon'] = iconPath;
    if (link != null) data['link'] = link;
    if (infoByLocale != null) data['info'] = infoByLocale;

    return data;
  }
}

class WebsiteProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  void _errorHandler(e, context) {
    print(e.message);
    if (context != null) {
      if (e.message.contains('PERMISSION_DENIED')) {
        AppToast.show(S.of(context).errorPermissionDenied);
      } else {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }
  }

  Future<List<Website>> fetchWebsites(Filter filter,
      {bool userOnly = false, String uid}) async {
    try {
      List<Website> websites = [];

      if (!userOnly) {
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

        documents = documents
            .where((doc) => seenDocumentIds.add(doc.documentID))
            .toList();

        websites.addAll(documents.map((doc) => WebsiteExtension.fromSnap(doc)));
      }

      // Get user-added websites
      if (uid != null) {
        DocumentReference ref =
            Firestore.instance.collection('users').document(uid);
        QuerySnapshot qSnapshot =
            await ref.collection('websites').getDocuments();

        websites.addAll(qSnapshot.documents
            .map((doc) => WebsiteExtension.fromSnap(doc, ownerUid: uid)));
      }

      return websites;
    } catch (e) {
      _errorHandler(e, null);
      return null;
    }
  }

  Future<bool> addWebsite(Website website,
      {bool updateExisting = false, BuildContext context}) async {
    assert(website.label != null);
    assert(context != null);

    try {
      DocumentReference ref;
      if (!website.isPrivate) {
        ref = _db.collection('websites').document(website.id);
      } else {
        ref = _db
            .collection('users')
            .document(website.ownerUid)
            .collection('websites')
            .document(website.id);
      }

      if ((await ref.get()).data != null && !updateExisting) {
        // TODO: Properly check if a website with a similar name/link already exists
        print('A website with id ${website.id} already exists');
        AppToast.show(S.of(context).warningWebsiteNameExists);
        return false;
      }

      var data = website.toData();
      await ref.setData(data);

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  /// Check if there is at least one website that the [user] has permission to edit
  Future<bool> hasEditableWebsites(User user) async {
    // We assume there is at least one public website in the database
    if (user.canEditPublicWebsite) return true;

    CollectionReference ref =
        _db.collection('users').document(user.uid).collection('websites');
    return (await ref.getDocuments()).documents.length > 0;
  }
}
