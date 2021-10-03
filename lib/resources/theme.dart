import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF43ACCD);

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
// The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  toggleableActiveColor: primaryColor,
  fontFamily: 'Montserrat',
  primaryColor: primaryColor,
  chipTheme: chipThemeData(Brightness.light),
);

var darkThemeData = ThemeData(
  brightness: Brightness.dark,
// The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  toggleableActiveColor: primaryColor,
  fontFamily: 'Montserrat',
  primaryColor: primaryColor,
  chipTheme: chipThemeData(Brightness.dark),
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

  Color get secondaryButtonColor {
    switch (brightness) {
      case Brightness.dark:
        return backgroundColor;
      case Brightness.light:
        return Colors.grey.shade200;
    }
    return Colors.grey.shade200;
  }
}
