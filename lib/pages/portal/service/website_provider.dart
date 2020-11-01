import 'dart:async';
import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:provider/provider.dart';

extension UserExtension on User {
  /// Check if there is at least one website that the [User] has permission to edit
  Future<bool> get hasEditableWebsites async {
    // We assume there is at least one public website in the database
    if (canEditPublicInfo) return true;
    return hasPrivateWebsites;
  }

  /// Check if user has at least one private website
  Future<bool> get hasPrivateWebsites async {
    final CollectionReference ref = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('websites');
    return (await ref.getDocuments()).documents.isNotEmpty;
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
    final data = <String, dynamic>{};

    if (!isPrivate) {
      if (ownerUid != null) data['addedBy'] = ownerUid;
      data['editedBy'] = editedBy;
      data['relevance'] = relevance;
      if (degree != null) data['degree'] = degree;
    }

    if (label != null) data['label'] = label;
    if (category != null) {
      data['category'] = category.toShortString();
    }
    if (link != null) data['link'] = link;
    if (infoByLocale != null) data['info'] = infoByLocale;

    return data;
  }
}

class WebsiteProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  void _errorHandler(dynamic e, BuildContext context) {
    print(e.message);
    if (context != null) {
      if (e.message.contains('PERMISSION_DENIED')) {
        AppToast.show(S.of(context).errorPermissionDenied);
      } else {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
    }
  }

  /// Initializes the number of visits of websites with the value stored from Firebase.
  Future<bool> _initializeNumberOfVisits(
      List<Website> websites, String uid) async {
    if (uid == null) {
      return _initializeNumberOfVisitsLocally(websites);
    }
    try {
      final DocumentReference doc = _db.collection('users').document(uid);
      final DocumentSnapshot snap = await doc.get();

      final websiteVisits =
          Map<String, dynamic>.from(snap.data['websiteVisits'] ?? {});
      for (final website in websites) {
        website.numberOfVisits = websiteVisits[website.id] ?? 0;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Initializes the number of visits of websites with the value stored locally.
  /// This method is used when user is anonymous because he hasn't info saved on Firestore
  ///
  /// Because [PrefService] doesn't support storing maps, the
  /// data is stored in 2 lists: the list of website IDs ([websiteIds]) and the list
  /// with the number of visits ([websiteVisits]), where `websiteVisits[i]` is the
  /// number of times the user accessed website with ID `websiteIds[i]`.
  Future<bool> _initializeNumberOfVisitsLocally(List<Website> websites) async {
    try {
      final List<String> websiteIds =
          PrefService.sharedPreferences.getStringList('websiteIds') ?? [];
      final List<String> websiteVisits =
          PrefService.sharedPreferences.getStringList('websiteVisits') ?? [];

      final visitsByWebsiteId = Map<String, int>.from(websiteIds.asMap().map(
          (index, key) =>
              MapEntry(key, int.tryParse(websiteVisits[index] ?? 0))));
      for (final Website website in websites) {
        website.numberOfVisits = visitsByWebsiteId[website.id] ?? 0;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Increments the number of visits of [website], both in-memory and on Firebase.
  Future<bool> incrementNumberOfVisits(Website website,
      {@required String uid}) async {
    try {
      website.numberOfVisits++;
      if (uid == null) {
        return await incrementNumberOfVisitsLocally(website);
      }
      final DocumentReference doc = _db.collection('users').document(uid);
      final DocumentSnapshot snap = await doc.get();
      final websiteVisits =
          Map<String, dynamic>.from(snap.data['websiteVisits'] ?? {});
      websiteVisits[website.id] = website.numberOfVisits++;

      await doc.updateData({'websiteVisits': websiteVisits});
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Increments the number of visits of [website], both in-memory and on the local storage.
  /// This method is used when user is anonymous because he hasn't info saved on Firestore
  ///
  /// Because [PrefService] doesn't support storing maps, the
  /// data is stored in 2 lists: the list of website IDs ([websiteIds]) and the list
  /// with the number of visits [websiteVisits], where `websiteVisits[i]` is the
  /// number of times the user accessed website with ID `websiteIds[i]`.
  Future<bool> incrementNumberOfVisitsLocally(Website website) async {
    try {
      website.numberOfVisits++;
      final List<String> websiteIds =
          PrefService.sharedPreferences.getStringList('websiteIds') ?? [];
      final List<String> websiteVisits =
          PrefService.sharedPreferences.getStringList('websiteVisits') ?? [];

      if (websiteIds.contains(website.id)) {
        final int index = websiteIds.indexOf(website.id);
        websiteVisits.insert(index, website.numberOfVisits.toString());
      } else {
        websiteIds.add(website.id);
        websiteVisits.add(website.numberOfVisits.toString());
        await PrefService.sharedPreferences
            .setStringList('websiteIds', websiteIds);
      }
      await PrefService.sharedPreferences
          .setStringList('websiteVisits', websiteVisits);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Website>> fetchWebsites(Filter filter,
      {bool userOnly = false, String uid, BuildContext context}) async {
    try {
      final websites = <Website>[];

      if (!userOnly) {
        List<DocumentSnapshot> documents = [];

        if (filter == null) {
          final QuerySnapshot qSnapshot =
              await _db.collection('websites').getDocuments();
          documents.addAll(qSnapshot.documents);
        } else {
          // Documents without a 'relevance' field are relevant for everyone
          final query =
              _db.collection('websites').where('relevance', isNull: true);
          final QuerySnapshot qSnapshot = await query.getDocuments();
          documents.addAll(qSnapshot.documents);

          for (final string in filter.relevantNodes) {
            // selected nodes
            final query = _db
                .collection('websites')
                .where('degree', isEqualTo: filter.baseNode)
                .where('relevance', arrayContains: string);
            final QuerySnapshot qSnapshot = await query.getDocuments();
            documents.addAll(qSnapshot.documents);
          }
        }

        // Remove duplicates
        // (a document may result out of more than one query)
        final seenDocumentIds = <String>{};

        documents = documents
            .where((doc) => seenDocumentIds.add(doc.documentID))
            .toList();

        websites.addAll(documents.map(WebsiteExtension.fromSnap));
      }

      // Get user-added websites
      if (uid != null) {
        final DocumentReference ref =
            Firestore.instance.collection('users').document(uid);
        final QuerySnapshot qSnapshot =
            await ref.collection('websites').getDocuments();

        websites.addAll(qSnapshot.documents
            .map((doc) => WebsiteExtension.fromSnap(doc, ownerUid: uid)));
      }

      final bool initializeReturnSuccess = await _initializeNumberOfVisits(
          websites,
          Provider.of<AuthProvider>(context, listen: false).isAnonymous == true
              ? null
              : uid);
      if (!initializeReturnSuccess) {
        AppToast.show(
            S.of(context).warningFavouriteWebsitesInitializationFailed);
      }
      websites.sort((website1, website2) =>
          website2.numberOfVisits.compareTo(website1.numberOfVisits));

      return websites;
    } catch (e) {
      _errorHandler(e, null);
      return null;
    }
  }

  Future<List<Website>> fetchFavouriteWebsites(
      {int limit = 3, String uid, BuildContext context}) async {
    final favouriteWebsites =
        (await fetchWebsites(null, uid: uid, context: context))
            .where((website) => website.numberOfVisits > 0)
            .take(limit)
            .toList();
    if (favouriteWebsites.isEmpty) {
      return null;
    }
    return favouriteWebsites;
  }

  Future<bool> addWebsite(Website website, {BuildContext context}) async {
    assert(website.label != null);

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

      if ((await ref.get()).data != null) {
        // TODO(IoanaAlexandru): Properly check if a website with a similar name/link already exists
        print('A website with id ${website.id} already exists');
        if (context != null) {
          AppToast.show(S.of(context).warningWebsiteNameExists);
        }
        return false;
      }

      final data = website.toData();
      await ref.setData(data);

      notifyListeners();
      return true;
    } catch (e) {
      _errorHandler(e, context);
      return false;
    }
  }

  Future<bool> updateWebsite(Website website, {BuildContext context}) async {
    assert(website.label != null);

    try {
      final DocumentReference publicRef =
          _db.collection('websites').document(website.id);
      final DocumentReference privateRef = _db
          .collection('users')
          .document(website.ownerUid)
          .collection('websites')
          .document(website.id);

      DocumentReference previousRef;
      bool wasPrivate;
      if ((await publicRef.get()).data != null) {
        wasPrivate = false;
        previousRef = publicRef;
      } else if ((await privateRef.get()).data != null) {
        wasPrivate = true;
        previousRef = privateRef;
      } else {
        print('Website not found.');
        return false;
      }

      if (wasPrivate == website.isPrivate) {
        // No privacy change
        await previousRef.updateData(website.toData());
      } else {
        // Privacy changed
        await previousRef.delete();
        await (wasPrivate ? publicRef : privateRef).setData(website.toData());
      }

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
}
