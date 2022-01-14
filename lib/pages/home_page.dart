import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/pages/home_loading_page.dart';
import 'package:palpites_da_loteria/widgets/card_concursos.dart';
import 'package:palpites_da_loteria/widgets/concursos_settings_change_notifier.dart';
import 'package:provider/provider.dart';

import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<CardConcursos> cards;
  ConcursosSettingsChangeNotifier concursosProvider;
  Concursos concursos;

  @override
  void initState() {
    super.initState();
    AdMobService.startConcursosBanner()..load();
    // AdMobService.displayConcursosBanner();
  }

  @override
  Widget build(BuildContext context) {

    var mediaQueryData = MediaQuery.of(context);
    var isPortrait = mediaQueryData.orientation == Orientation.portrait;

    var screenWidth = mediaQueryData.size.width;
    var portraitSize = screenWidth / 2;
    var landscapeSize = screenWidth / 4;
    var tileSize = isPortrait ?
    (portraitSize > Constants.tileMaxSize ? Constants.tileMaxSize: portraitSize)
        : (landscapeSize > Constants.tileMaxSize ? Constants.tileMaxSize: landscapeSize) ;

    var spacing = mediaQueryData.size.height / 100;

    concursosProvider = Provider.of<ConcursosSettingsChangeNotifier>(context);
    concursos = concursosProvider.getConcursos();

    if (concursosProvider != null && concursos != null) {
      cards = concursos
          .where((element) => element.enabled)
          .map((concurso) => CardConcursos(concurso))
          .toList();

      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
          child: Center(
              child: GridView(
                padding: EdgeInsets.all(spacing),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  maxCrossAxisExtent: tileSize,
                ),
                children: cards,
              )),
        ),
      );

    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
        child: Scaffold(
          appBar: AppBar(
            title: Text(Strings.appName),
          ),
          drawer: Drawer(
            child: AppDrawer(),
          ),
          body: HomeLoadingPage(spacing: spacing, tileSize: tileSize),
        ),
      );
    }
  }
}
