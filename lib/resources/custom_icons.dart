import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';

  static const IconData facebook = const IconData(0xf09a, fontFamily: _kFontFam);
  static const IconData google = const IconData(0xf1a0, fontFamily: _kFontFam);

  static const Icon valid = Icon(Icons.check_circle, color: Colors.green);
  static const Icon invalid = Icon(Icons.cancel, color: Colors.red);
  // Transparent icon to be used as a placeholder
  static const Icon empty = Icon(Icons.cancel, color: Color(0));
}