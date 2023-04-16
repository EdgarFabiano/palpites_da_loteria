import 'package:flutter/material.dart';

class DefaultThemes {
  static final Color primaryLight = Colors.indigo;
  static final Color primaryDark = Colors.black87;

  static final Color megaSena = Color.fromARGB(255, 32, 152, 105);
  static final Color lotofacil = Color.fromARGB(255, 149, 67, 137);
  static final Color quina = Color.fromARGB(255, 45, 57, 133);
  static final Color lotomania = Color.fromARGB(255, 247, 132, 74);
  static final Color timemania = Color.fromARGB(255, 94, 232, 79);
  static final Color duplaSena = Color.fromARGB(255, 166, 42, 49);
  static final Color diaDeSorte = Color.fromARGB(255, 203, 133, 59);

  static Color getRefreshingCardColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white70;
    } else {
      return Colors.black12;
    }
  }

  static ThemeData appTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        useMaterial3: true);
  }

  static ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
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
