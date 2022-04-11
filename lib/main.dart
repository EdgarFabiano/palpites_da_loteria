import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/service/concurso_service.dart'
    as concursoService;
import 'package:palpites_da_loteria/pages/home_page.dart';
import 'package:palpites_da_loteria/widgets/concursos_settings_change_notifier.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAdMob.instance.initialize(appId: AdMobService.getAppId());
  MobileAds.instance.initialize();
  runApp(PalpitesLoteriaApp());
}

class PalpitesLoteriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConcursosSettingsChangeNotifier concursosSettingsChangeNotifier =
        ConcursosSettingsChangeNotifier();
    concursoService
        .getUsersConcursosFuture()
        .then((value) => concursosSettingsChangeNotifier.setConcursos(value));

    return new EasyDynamicThemeWidget(
      child: MultiProvider(
        child: ConcursosMaterialApp(),
        providers: [
          ChangeNotifierProvider<ConcursosSettingsChangeNotifier>(
            create: (_) => concursosSettingsChangeNotifier,
          ),
          /*StreamProvider<DataConnectionStatus>(
            create: (context) {
              return DataConnectivityService()
                  .connectivityStreamController
                  .stream;
            },
            initialData: DataConnectionStatus.connected,
          )*/
        ],
      ),
    );
  }
}

class ConcursosMaterialApp extends StatelessWidget {
  ConcursosMaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.indigo),
      darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.indigo),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
