
import 'package:flutter/material.dart';

class Themes {

  static ThemeData AppTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      secondaryHeaderColor: Colors.yellow,
      accentColor: Colors.red,
    );
  }

}