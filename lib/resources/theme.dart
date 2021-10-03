import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF4DB5E4);
Color accentColor = const Color(0xFF43ACCD);

Color chipSelectedColor(Brightness brightness) =>
    brightness == Brightness.light ? accentColor.withOpacity(0.3) : accentColor;

ChipThemeData chipThemeData(Brightness brightness) =>
    ChipThemeData.fromDefaults(
      brightness: brightness,
      secondaryColor: accentColor,
      labelStyle: ThemeData()
          .accentTextTheme
          .apply(
              fontFamily: 'Montserrat',
              bodyColor: accentColor,
              displayColor: accentColor)
          .bodyText2,
    ).copyWith(
      selectedColor: chipSelectedColor(brightness),
      secondarySelectedColor: chipSelectedColor(brightness),
      checkmarkColor:
          brightness == Brightness.light ? accentColor : Colors.white,
    );

var lightThemeData = ThemeData(
  brightness: Brightness.light,
  accentColor: accentColor,
// The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  accentTextTheme: ThemeData().accentTextTheme.apply(
      fontFamily: 'Montserrat',
      bodyColor: accentColor,
      displayColor: accentColor),
  toggleableActiveColor: accentColor,
  fontFamily: 'Montserrat',
  primaryColor: primaryColor,
  chipTheme: chipThemeData(Brightness.light),
);

var darkThemeData = ThemeData(
  brightness: Brightness.dark,
  accentColor: accentColor,
// The following two lines are meant to remove the splash effect
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  accentTextTheme: ThemeData().accentTextTheme.apply(
      fontFamily: 'Montserrat',
      bodyColor: accentColor,
      displayColor: accentColor),
  toggleableActiveColor: accentColor,
  fontFamily: 'Montserrat',
  primaryColor: primaryColor,
  chipTheme: chipThemeData(Brightness.dark),
);

extension ThemeExtension on ThemeData {
  TextStyle chipTextStyle({@required bool selected}) => TextStyle(
        color: selected
            ? brightness == Brightness.light
                ? accentColor
                : Colors.white
            : textTheme.bodyText2.color,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      );

  Color get formIconColor {
    switch (brightness) {
      case Brightness.dark:
        return Colors.white70;
      case Brightness.light:
        return Colors.black45;
      default:
        return iconTheme.color;
    }
  }

  Color get secondaryButtonColor {
    switch (brightness) {
      case Brightness.dark:
        return backgroundColor;
      case Brightness.light:
        return buttonColor;
      default:
        return buttonColor;
    }
  }
}
