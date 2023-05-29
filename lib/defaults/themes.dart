import 'package:flutter/material.dart';

class DefaultThemes {

  static ThemeData appTheme(useMaterial3) {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        useMaterial3: useMaterial3);
  }

  static ThemeData darkTheme(useMaterial3) {
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: useMaterial3);
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
