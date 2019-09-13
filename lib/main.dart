import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/ui/HomePage.dart';
import 'package:palpites_da_loteria/util/Strings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(new PalpitesLoteriaApp());

class PalpitesLoteriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: Strings.appName,
            theme: theme,
            home: new HomePage(title: Strings.appName),
          );
        }
    );
  }
}

