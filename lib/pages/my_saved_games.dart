import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/widgets/my_saved_games_tab_item.dart';

import '../defaults/constants.dart';
import '../defaults/strings.dart';
import '../model/contest.dart';
import '../model/loteria_banner_ad.dart';
import '../model/saved_game.dart';
import '../service/admob_service.dart';
import '../service/contest_service.dart';
import '../service/saved_game_service.dart';
import '../widgets/custom_tab_view.dart';

class MySavedGames extends StatefulWidget {
  const MySavedGames({Key? key}) : super(key: key);

  @override
  State<MySavedGames> createState() => _MySavedGamesState();
}

class _MySavedGamesState extends State<MySavedGames>
    with TickerProviderStateMixin {
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.meusJogosBannerId);

  SavedGameService _savedGameService = SavedGameService();
  ContestService _contestService = ContestService();

  List<Contest> _contests = [];
  TabController? _tabController;
  List<Tab> _tabs = [];
  int initPosition = 0;

  Future<bool> _asyncInit() async {
    _contests = await _contestService.getContestsWithSavedGames();
    _tabs = _contests.map((e) => Tab(child: Text(e.name))).toList();
    if (_tabController == null) {
      _tabController = TabController(vsync: this, length: _tabs.length);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.mySavedGames),
          actions: <Widget>[_buildAddRandomButton()],
        ),
        body: Center(
          child: FutureBuilder<bool>(
            future: _asyncInit(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (_contests.isEmpty) {
                  return const Center(
                    child: Text("Nenhum jogo salvo"),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomTabView(
                            initPosition: initPosition,
                            itemCount: _contests.length,
                            tabBuilder: (context, index) =>
                                Tab(text: _contests[index].name),
                            pageBuilder: (context, index) => MySavedGamesTabItem(
                                contest: _contests[index],
                                notifyParent: _updateUI),
                            onPositionChange: (index) {
                              initPosition = index;
                            },
                          ),
                        ),
                        AdMobService.getBannerAdWidget(_bannerAd),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _updateUI() async {
    setState(() {});
  }

  IconButton _buildAddRandomButton() {
    return IconButton(
      onPressed: () async {
        await _savedGameService.addSavedGame(
          SavedGame(
            contestId: Random.secure().nextInt(7) + 1,
            numbers: '1|2|3|4|5',
            createdAt: DateTime.now(),
          ),
        );
        _updateUI();
      },
      icon: Icon(Icons.add),
    );
  }
}
