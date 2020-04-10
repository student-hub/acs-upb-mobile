import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:validators/sanitizers.dart';

enum WebsiteCategory { learning, administrative, association, resource, other }

extension WebsiteCategoryExtension on WebsiteCategory {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case WebsiteCategory.learning:
        return S.of(context).websiteCategoryLearning;
      case WebsiteCategory.administrative:
        return S.of(context).websiteCategoryAdministrative;
      case WebsiteCategory.association:
        return S.of(context).websiteCategoryAssociations;
      case WebsiteCategory.resource:
        return S.of(context).websiteCategoryResources;
      default:
        return S.of(context).websiteCategoryOthers;
    }
  }
}

class Website {
  final WebsiteCategory category;
  final String iconPath;
  final String label;
  final String link;
  final Map<String, String> infoByLocale;

  Website(
      {@required this.category,
      this.iconPath,
      String label,
      @required String link,
      this.infoByLocale})
      : this.label = toString(label).isEmpty ? labelFromLink(link) : label,
        this.link = link;

  static String labelFromLink(String link) => link.split('://').last;
}
