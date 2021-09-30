import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';

import '../../../generated/l10n.dart';

enum WebsiteCategory { learning, administrative, association, resource, other }

extension WebsiteCategoryExtension on WebsiteCategory {
  String toLocalizedString() {
    switch (this) {
      case WebsiteCategory.learning:
        return S.current.websiteCategoryLearning;
      case WebsiteCategory.administrative:
        return S.current.websiteCategoryAdministrative;
      case WebsiteCategory.association:
        return S.current.websiteCategoryAssociations;
      case WebsiteCategory.resource:
        return S.current.websiteCategoryResources;
      case WebsiteCategory.other:
        return S.current.websiteCategoryOthers;
    }
    return S.current.websiteCategoryOthers;
  }
}

class Website {
  Website({
    @required this.id,
    @required this.isPrivate,
    @required this.category,
    @required this.link,
    @required this.relevance,
    this.degree,
    List<String> editedBy,
    this.ownerUid,
    String label,
    Map<String, String> infoByLocale,
  })  : editedBy = editedBy ?? [],
        label = toString(label).isEmpty ? labelFromLink(link) : label,
        infoByLocale = infoByLocale ?? {} {
    if (relevance != null && !relevance.contains('All')) {
      if (degree == null) {
        throw ArgumentError(
            'If the relevance is not null, the degree cannot be null.');
      }
    }
  }

  String get iconPath =>
      isPrivate ? 'users/$ownerUid/websites/$id.png' : 'websites/$id/icon.png';

  /// The user who created this website (or null if it's public)
  final String ownerUid;

  /// The ID of this website
  final String id;

  /// Whether the website is public or part of user data
  final bool isPrivate;

  final List<String> editedBy;

  final WebsiteCategory category;
  final String label;
  final String link;
  final Map<String, String> infoByLocale;

  final String degree;
  final List<String> relevance;
  int numberOfVisits = 0;

  static String labelFromLink(String link) => link.split('://').last;
}
