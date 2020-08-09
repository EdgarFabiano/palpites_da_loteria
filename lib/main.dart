import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/ui/home-page.dart';
import 'package:palpites_da_loteria/ui/settings-page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'defaults/ad-units.dart';
import 'defaults/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdUnits.getAppId());
  runApp(PalpitesLoteriaApp());

  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  preferences.then((onValue) {
    onValue.setBool(Constants.updateHomeSharedPreferencesKey, false);
  });
}

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
              initialRoute: Strings.concursosRoute,
              routes: {
                Strings.configuracoesRoute: (context) => SettingsPage(),
              });
        });
  }
}
