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
  final Contest? initPositionContest;
  const MySavedGames({Key? key, this.initPositionContest}) : super(key: key);

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
  int _initPosition = 0;
  Contest? _currentContest;

  Future<bool> _asyncInit() async {
    _contests = await _contestService.getContestsWithSavedGames();
    if (_currentContest != null) {
      _initPosition = _contests.indexOf(_currentContest!);
      if(_initPosition < 0) {
        _initPosition = 0;
        _currentContest = null;
      }
    }
    _tabs = _contests.map((e) => Tab(child: Text(e.name))).toList();
    if (_tabController == null) {
      _tabController = TabController(vsync: this, length: _tabs.length);
    }
    return true;
  }

  @override
  void initState() {
    _currentContest = widget.initPositionContest;
    super.initState();
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<bool>(
        future: _asyncInit(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(Strings.mySavedGames),
                actions: <Widget>[_buildAddRandomButton()],
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (_contests.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(Strings.mySavedGames),
                  actions: <Widget>[_buildAddRandomButton()],
                ),
                body: const Center(
                  child: Text("Nenhum jogo salvo"),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text(Strings.mySavedGames),
                  actions: <Widget>[_buildAddRandomButton()],
                ),
                body: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomTabView(
                          initPosition: _initPosition,
                          itemCount: _contests.length,
                          colorBuilder: (context, index) => _contests[index].getColor(context),
                          tabBuilder: (context, index) => Tab(text: _contests[index].name),
                          pageBuilder: (context, index) => MySavedGamesTabItem(
                              contest: _contests[index],
                              notifyParent: _updateUI),
                          onPositionChange: (index) {
                            _initPosition = index;
                            _currentContest = _contests[index];
                          },
                        ),
                      ),
                      AdMobService.getBannerAdWidget(_bannerAd),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _updateUI(bool wasDeleted) async {
    if(wasDeleted) _currentContest = null;
    setState(() {});
  }

  Widget _buildAddRandomButton() {
    var iconButton = IconButton(
      onPressed: () async {
        await _savedGameService.addSavedGame(
          SavedGame(
            contestId: Random.secure().nextInt(7) + 1,
            numbers: '1|2|3|4|5',
            createdAt: DateTime.now(),
          ),
        );
        _updateUI(false);
      },
      icon: Icon(Icons.add),
    );
    return Container();
  }
}
