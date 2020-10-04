import 'package:acs_upb_mobile/generated/l10n.dart';
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
}

class Class {
  Class(
      {@required this.header,
      List<Shortcut> shortcuts,
      this.grading,
      this.gradingLastUpdated})
      : shortcuts = shortcuts ?? [];

  ClassHeader header;
  final List<Shortcut> shortcuts;
  final Map<String, double> grading;
  final LocalDateTime gradingLastUpdated;
}
