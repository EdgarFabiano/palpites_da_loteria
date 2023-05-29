import 'package:flutter/material.dart';

class DefaultThemes {
  static ThemeData appTheme() {
    return ThemeData(
        primarySwatch: Colors.indigo, brightness: Brightness.light,
        // colorScheme: ColorScheme.fromSwatch(
        //     primarySwatch: Colors.teal, brightness: Brightness.light, backgroundColor: Colors.white),
        useMaterial3: true);
  }

  static ThemeData darkTheme() {
    return ThemeData(
        primarySwatch: Colors.teal, brightness: Brightness.dark,
        // colorScheme: ColorScheme.fromSwatch(
        //     primarySwatch: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true);
  }

  static Color textColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static ButtonStyle flatButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      foregroundColor: textColor(context),
    );
  }
}
