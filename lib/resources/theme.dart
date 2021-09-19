import 'package:flutter/material.dart';

const int _primaryColorValue = 0xFF43ACCD;
Color primaryColor = const Color(_primaryColorValue);
MaterialColor primarySwatch = const MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFF7CDEFF),
    100: Color(0xFF71D4F5),
    200: Color(0xFF65CAEB),
    300: Color(0xFF65CAEB),
    400: Color(0xFF4EB6D7),
    500: Color(_primaryColorValue),
    600: Color(0xFF32A0C1),
    700: Color(0xFF2295B5),
    800: Color(0xFF1189A8),
    900: Color(0xFF007D9C),
  },
);

Color chipSelectedColor(Brightness brightness) => brightness == Brightness.light
    ? primaryColor.withOpacity(0.3)
    : primaryColor;

ChipThemeData chipThemeData(Brightness brightness) =>
    ChipThemeData.fromDefaults(
      brightness: brightness,
      secondaryColor: primaryColor,
      labelStyle: ThemeData().coloredTextTheme.bodyText2,
    ).copyWith(
      selectedColor: chipSelectedColor(brightness),
      secondarySelectedColor: chipSelectedColor(brightness),
      checkmarkColor:
          brightness == Brightness.light ? primaryColor : Colors.white,
    );

var lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  // This is deprecated, but some packages still use it.
  accentColor: primaryColor,
  // The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  toggleableActiveColor: primaryColor,
  fontFamily: 'Montserrat',
  chipTheme: chipThemeData(Brightness.light),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.light,
    primarySwatch: primarySwatch,
  ),
);

var darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  // This is deprecated, but some packages still use it.
  accentColor: primaryColor,
  // The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  toggleableActiveColor: primaryColor,
  fontFamily: 'Montserrat',
  chipTheme: chipThemeData(Brightness.dark),
  colorScheme: ColorScheme.fromSwatch(
    brightness: Brightness.dark,
    primarySwatch: primarySwatch,
  ),
);

extension ThemeExtension on ThemeData {
  TextStyle chipTextStyle({@required bool selected}) => TextStyle(
        color: selected
            ? brightness == Brightness.light
                ? primaryColor
                : Colors.white
            : textTheme.bodyText2.color,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      );

  // Coloured text, usually highlighting that it can be pressed, similar to
  // HTML links.
  TextTheme get coloredTextTheme => textTheme.apply(
        fontFamily: 'Montserrat',
        bodyColor: primaryColor,
        displayColor: primaryColor,
      );

  Color get formIconColor {
    switch (brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
    }
    return iconTheme.color;
  }
}
