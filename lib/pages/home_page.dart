import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../defaults/defaults_export.dart';
import '../model/loteria_banner_ad.dart';
import '../model/model_export.dart';
import '../service/admob_service.dart';
import '../widgets/card_concursos.dart';
import '../widgets/concursos_settings_change_notifier.dart';
import 'app_drawer.dart';
import 'home_loading_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardConcursos>? cards;
  ConcursosSettingsChangeNotifier? concursosProvider;
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.concursosBannerId);

  @override
  void initState() {
    super.initState();
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Contest>? _contests;
    var mediaQueryData = MediaQuery.of(context);
    var isPortrait = mediaQueryData.orientation == Orientation.portrait;

    var screenWidth = mediaQueryData.size.width;
    var portraitSize = screenWidth / 2;
    var landscapeSize = screenWidth / 4;
    var tileSize = isPortrait
        ? (portraitSize > Constants.tileMaxSize
            ? Constants.tileMaxSize
            : portraitSize)
        : (landscapeSize > Constants.tileMaxSize
            ? Constants.tileMaxSize
            : landscapeSize);

    var spacing = mediaQueryData.size.height / 100;

    concursosProvider = Provider.of<ConcursosSettingsChangeNotifier>(context);
    _contests = concursosProvider?.getContests();

    if (concursosProvider != null && _contests != null) {
      cards = _contests
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
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: GridView(
                  padding: EdgeInsets.all(spacing),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    maxCrossAxisExtent: tileSize,
                  ),
                  children: cards!,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                ),
              ),
              AdMobService.getBannerAdWidget(_bannerAd),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appName),
        ),
        drawer: Drawer(
          child: AppDrawer(),
        ),
        body: HomeLoadingPage(spacing: spacing, tileSize: tileSize),
      );
    }
  }
}
