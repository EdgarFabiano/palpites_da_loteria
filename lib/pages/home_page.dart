import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../defaults/defaults_export.dart';
import '../model/loteria_banner_ad.dart';
import '../model/model_export.dart';
import '../service/admob_service.dart';
import '../widgets/contest_card.dart';
import '../widgets/contests_settings_change_notifier.dart';
import 'app_drawer.dart';
import 'home_loading_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ContestCard>? cards;
  ContestsSettingsChangeNotifier? contestsProvider;
  LotteryBannerAd _bannerAd =
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

    contestsProvider = Provider.of<ContestsSettingsChangeNotifier>(context);
    _contests = contestsProvider?.getContests();

    if (contestsProvider != null && _contests != null) {
      cards = _contests
          .where((element) => element.enabled)
          .map((concurso) => ContestCard(concurso))
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
              if (cards!.isNotEmpty)
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
              if (cards!.isEmpty)
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: DefaultThemes.textColor(context),
                              ),
                              Text(
                                "Recarregar",
                                style: TextStyle(
                                    color: DefaultThemes.textColor(context)),
                              ),
                            ]),
                      ),
                      onPressed: () => setState(() {}),
                    ),
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
