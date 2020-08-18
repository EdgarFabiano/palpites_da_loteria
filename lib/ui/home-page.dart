import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/defaults/strings.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/ui/home-loading-page.dart';
import 'package:palpites_da_loteria/widgets/card-concursos.dart';
import 'package:palpites_da_loteria/widgets/concursos-settings-change-notifier.dart';
import 'package:provider/provider.dart';

import 'app-drawer.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    List<CardConcursos> cards;
    var mediaQueryData = MediaQuery.of(context);
    var isPortrait = mediaQueryData.orientation == Orientation.portrait;

    var screenWidth = mediaQueryData.size.width;
    var portraitSize = screenWidth / 2;
    var landscapeSize = screenWidth / 4;
    var tileSize = isPortrait ?
    (portraitSize > Constants.tileMaxSize ? Constants.tileMaxSize: portraitSize)
        : (landscapeSize > Constants.tileMaxSize ? Constants.tileMaxSize: landscapeSize) ;

    var spacing = mediaQueryData.size.height / 100;

    var concursosProvider = Provider.of<ConcursosSettingsChangeNotifier>(context);
    Concursos concursos = concursosProvider.getConcursos();
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
          padding: EdgeInsets.only(bottom: AdMobService.getBannerSize(context)),
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
        bottomSheet: AdMobService.getConcursosBanner(),
      );

    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: AdMobService.getBannerSize(context)),
          child: HomeLoadingPage(spacing: spacing, tileSize: tileSize),
        ),
        bottomSheet: AdMobService.getConcursosBanner(),
      );
    }
  }
}
