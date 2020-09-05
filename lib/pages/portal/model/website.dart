import 'dart:collection';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';
import 'package:preferences/preference_service.dart';
import 'dart:convert';

enum WebsiteCategory { learning, administrative, association, resource, other }

extension WebsiteCategoryExtension on WebsiteCategory {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case WebsiteCategory.learning:
        return S
            .of(context)
            .websiteCategoryLearning;
      case WebsiteCategory.administrative:
        return S
            .of(context)
            .websiteCategoryAdministrative;
      case WebsiteCategory.association:
        return S
            .of(context)
            .websiteCategoryAssociations;
      case WebsiteCategory.resource:
        return S
            .of(context)
            .websiteCategoryResources;
      default:
        return S
            .of(context)
            .websiteCategoryOthers;
    }
  }
}

class Website {
  /// The user who created this website (or null if it's public)
  final String ownerUid;

  /// The ID of this website
  final String id;

  /// Whether the website is public or part of user data
  final bool isPrivate;

  final List<String> editedBy;

  final WebsiteCategory category;
  final String iconPath;
  final String label;
  final String link;
  final Map<String, String> infoByLocale;

  final String degree;
  final List<String> relevance;
  int numberOfVisits = 0;

  Website({this.ownerUid,
    @required this.id,
    @required this.isPrivate,
    List<String> editedBy,
    @required this.category,
    this.iconPath,
    String label,
    @required String link,
    Map<String, String> infoByLocale,
    this.degree,
    @required this.relevance})
      : this.editedBy = editedBy ?? [],
        this.label = toString(label).isEmpty ? labelFromLink(link) : label,
        this.link = link,
        this.infoByLocale = infoByLocale ?? {} {
    if (this.relevance != null) {
      if (this.degree == null) {
        throw ArgumentError(
            'If the relevance is not null, the degree cannot be null.');
      }
    }
  }

  static String labelFromLink(String link) =>
      link
          .split('://')
          .last;
}
