import 'dart:async';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

extension UserExtension on User {
  /// Check if there is at least one website that the [user] has permission to edit
  Future<bool> get hasEditableWebsites async {
    // We assume there is at least one public website in the database
    if (canEditPublicWebsite) return true;
    return await hasPrivateWebsites;
  }

  /// Check if user has at least one private website
  Future<bool> get hasPrivateWebsites async {
    CollectionReference ref = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('websites');
    return (await ref.getDocuments()).documents.length > 0;
  }
}

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
      degree: snap.data['degree'],
      relevance: snap.data['relevance'] == null
          ? null
          : List<String>.from(snap.data['relevance']),
    );
  }

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};

    if (!isPrivate) {
      if (ownerUid != null) data['addedBy'] = ownerUid;
      data['editedBy'] = editedBy;
      data['relevance'] = relevance;
      if (degree != null) data['degree'] = degree;
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

  ///This method initializes the number of visits of websites with the value
  /// accumulated until then. These data are stored in 2 lists: the list of website ids
  /// and the list with the number of accesses, according to the index in the list
  void initializeNumberOfVisits(List<Website> websites) {
    List<String> websiteIds =
        PrefService.sharedPreferences.getStringList("websiteIds");
    List<String> visitsByWebsiteId =
        PrefService.sharedPreferences.getStringList("visitsByWebsiteId");

    if (websiteIds != null && visitsByWebsiteId != null) {
      var idsMap = Map<String, int>.from(websiteIds.asMap().map((index, key) =>
          MapEntry(key, int.tryParse(visitsByWebsiteId[index] ?? 0))));
      websites.forEach((website) {
        if (idsMap[website.id] != null) {
          website.numberOfVisits = idsMap[website.id];
        }
      });
    }
  }

  ///this method increment the number of visits of websites when it is accessed
  /// by the user. In case the site has not been saved until now, it creates
  /// another element in the 2 lists(id and visits) for the respective site
  void incrementNumberOfVisits(Website website) async {
    website.numberOfVisits++;
    List<String> websiteIds =
        PrefService.sharedPreferences.getStringList("websiteIds") ?? [];
    List<String> visitsByWebsiteId =
        PrefService.sharedPreferences.getStringList("visitsByWebsiteId") ?? [];
    if (websiteIds.contains(website.id)) {
      int index = websiteIds.indexOf(website.id);
      visitsByWebsiteId.insert(index, visitsByWebsiteId.toString());
    } else {
      websiteIds.add(website.id);
      visitsByWebsiteId.add(website.numberOfVisits.toString());
      PrefService.sharedPreferences.setStringList("websiteIds", websiteIds);
    }
    PrefService.sharedPreferences
        .setStringList("visitsByWebsiteId", visitsByWebsiteId);
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

      initializeNumberOfVisits(websites);
      websites.sort((website1, website2) =>
          website2.numberOfVisits.compareTo(website1.numberOfVisits));

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

  Future<bool> deleteWebsite(Website website, {BuildContext context}) async {
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

      await ref.delete();

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  void updateVisits(Website website) async {
    website.numberOfVisits++;
    List<String> websitesId =
        PrefService.sharedPreferences.getStringList("websitesId");
    List<String> visitsByWebsiteId =
        PrefService.sharedPreferences.getStringList("visitsByWebsiteId");
    if (websitesId == null || visitsByWebsiteId == null) {
      websitesId = new List<String>();
      visitsByWebsiteId = new List<String>();
    }
    if (websitesId.contains(websitesId)) {
      int index = websitesId.indexOf(website.id);
      visitsByWebsiteId.insert(index, visitsByWebsiteId.toString());
    } else {
      websitesId.add(website.id);
      visitsByWebsiteId.add(website.numberOfVisits.toString());
      PrefService.sharedPreferences.setStringList("websiteIds", websitesId);
    }
    PrefService.sharedPreferences
        .setStringList("visitsByWebsiteId", visitsByWebsiteId);
  }
}
