import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';
import 'package:palpites_da_loteria/ui/home-page.dart';
import 'package:palpites_da_loteria/ui/settings-page.dart';
import 'package:palpites_da_loteria/widgets/concursos-settings-change-notifier.dart';
import 'package:provider/provider.dart';

import 'service/admob-service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdMobService.getAppId());
  runApp(PalpitesLoteriaApp());
}

class PalpitesLoteriaApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ConcursosSettingsChangeNotifier concursosSettingsChangeNotifier = ConcursosSettingsChangeNotifier();
    ConcursoService.getUsersConcursosFuture().then((value) => concursosSettingsChangeNotifier.setConcursos(value));
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
          return ChangeNotifierProvider<ConcursosSettingsChangeNotifier>(
            create: (_) => concursosSettingsChangeNotifier,
            child: ConcursosMaterialApp(theme),
          );
        });
  }
}

class ConcursosMaterialApp extends StatelessWidget {
  final ThemeData _theme;

  ConcursosMaterialApp(this._theme);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Strings.appName,
        theme: _theme,
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        initialRoute: Strings.concursosRoute,
        routes: {
          Strings.configuracoesRoute: (context) => SettingsPage(),
        });
  }
}
