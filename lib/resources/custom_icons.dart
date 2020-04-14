import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const _kFontPkg = null;

  // Custom font icons (see [CONTRIBUTING.md] for more info)
  static const IconData edit_slash =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData filter =
      IconData(0xf0b0, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  static const Icon valid = Icon(Icons.check_circle, color: Colors.green);
  static const Icon invalid = Icon(Icons.cancel, color: Colors.red);

  // Transparent icon to be used as a placeholder
  static const Icon empty = Icon(Icons.cancel, color: Color(0));
}
