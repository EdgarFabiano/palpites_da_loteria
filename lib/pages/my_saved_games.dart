import 'package:flutter/material.dart';

import '../defaults/constants.dart';
import '../defaults/strings.dart';
import '../model/loteria_banner_ad.dart';
import '../service/admob_service.dart';
import '../widgets/my_saved_games_crud.dart';

class MySavedGames extends StatefulWidget {
  const MySavedGames({Key? key}) : super(key: key);

  @override
  State<MySavedGames> createState() => _MySavedGamesState();
}

class _MySavedGamesState extends State<MySavedGames> {
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.meusJogosBannerId);

  @override
  void initState() {
    super.initState();
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.mySavedGames),
        actions: <Widget>[],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: MySavedGamesCRUD()),
            AdMobService.getBannerAdWidget(_bannerAd),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
