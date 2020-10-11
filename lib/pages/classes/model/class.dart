import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:time_machine/time_machine.dart';

enum ShortcutType { main, classbook, resource, other }

extension ShortcutTypeExtension on ShortcutType {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case ShortcutType.main:
        return S.of(context).shortcutTypeMain;
      case ShortcutType.classbook:
        return S.of(context).shortcutTypeClassbook;
      case ShortcutType.resource:
        return S.of(context).shortcutTypeResource;
      default:
        return S.of(context).shortcutTypeOther;
    }
  }
}

class Shortcut {
  Shortcut({this.type, this.name, this.link, this.ownerUid});

  final ShortcutType type;
  final String name;
  final String link;
  final String ownerUid;
}

class ClassHeader {
  ClassHeader({this.id, this.name, this.acronym, this.category});

  final String id;
  final String name;
  final String acronym;
  final String category;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ClassHeader) {
      return other.id == id;
    }
    return false;
  }
}

extension ClassExtension on ClassHeader {
  Color get colorFromAcronym {
    int r = 0, g = 0, b = 0;
    if (acronym.isNotEmpty) {
      b = acronym[0].codeUnitAt(0);
      if (acronym.length >= 2) {
        g = acronym[1].codeUnitAt(0);
        if (acronym.length >= 3) {
          r = acronym[2].codeUnitAt(0);
        }
      }
    }
    const int brightnessFactor = 2;
    return Color.fromRGBO(
        r * brightnessFactor, g * brightnessFactor, b * brightnessFactor, 1);
  }
}

class Class {
  Class(
      {@required this.header,
      List<Shortcut> shortcuts,
      this.grading,
      this.gradingLastUpdated,
      this.lecturer})
      : shortcuts = shortcuts ?? [];

  ClassHeader header;
  final List<Shortcut> shortcuts;
  final Map<String, double> grading;
  final LocalDateTime gradingLastUpdated;
  final Person lecturer;
}
