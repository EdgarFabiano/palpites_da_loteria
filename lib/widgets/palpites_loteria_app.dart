import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/pages/home_page.dart';
import 'package:palpites_da_loteria/service/concurso_service.dart'
    as concursoService;
import 'package:palpites_da_loteria/widgets/concursos_settings_change_notifier.dart';
import 'package:provider/provider.dart';

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
        ],
      ),
    );
  }
}

class ConcursosMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.indigo),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.grey),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
