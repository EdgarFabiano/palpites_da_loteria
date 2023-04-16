import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/pages/home_page.dart';
import 'package:palpites_da_loteria/widgets/concursos_settings_change_notifier.dart';
import 'package:provider/provider.dart';

import '../service/contest_service.dart';

class PalpitesLoteriaApp extends StatelessWidget {
  final ContestService _contestService = ContestService();

  @override
  Widget build(BuildContext context) {
    ConcursosSettingsChangeNotifier concursosSettingsChangeNotifier =
        ConcursosSettingsChangeNotifier();
    _contestService
        .initContests()
        .then((value) => concursosSettingsChangeNotifier.contests = value);

    return EasyDynamicThemeWidget(
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
      theme: DefaultThemes.appTheme(),
      darkTheme: DefaultThemes.darkTheme(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
