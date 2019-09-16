import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/Strings.dart';
import 'package:palpites_da_loteria/ui/HomePage.dart';

void main() => runApp(new PalpitesLoteriaApp());

class PalpitesLoteriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: Strings.appName,
            theme: theme,
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
