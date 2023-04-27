import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/tab_result.dart';
import 'package:palpites_da_loteria/widgets/tab_generate_guess.dart';
import 'package:share_plus/share_plus.dart';

import '../defaults/constants.dart';
import '../model/loteria_banner_ad.dart';
import '../model/saved_game.dart';
import '../service/saved_game_service.dart';
import 'my_saved_games.dart';

class GenerateGuessResult extends StatefulWidget {
  final Contest contest;

  GenerateGuessResult(this.contest, {Key? key}) : super(key: key);

  @override
  _GenerateGuessResultState createState() => _GenerateGuessResultState();
}

class _GenerateGuessResultState extends State<GenerateGuessResult>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = <Tab>[
    Tab(child: Text("Sorteio")),
    Tab(child: Text("Resultado")),
  ];
  int _activeTabIndex = 0;
  TabController? _tabController;
  LotteryAPIResult? _lotteryAPIResult;
  LotteryBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.generateGuessBannerId);
  SavedGameService _savedGameService = SavedGameService();
  int? _alreadySavedGameId;
  String _generatedGame = '';

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController!.index;
    });
  }

  void refreshResult(LotteryAPIResult? lotteryAPIResult) {
    setState(() {
      _lotteryAPIResult = lotteryAPIResult;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    if (Constants.showAds) {
      _bannerAd.load();
    }
  }

  @override
  void dispose() {
    print('Disposing $_tabController');
    _tabController!.dispose();
    print('Disposing $_bannerAd');
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: widget.contest.getColor(context),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
          ),
          title: Text(widget.contest.name),
          actions: <Widget>[
            if (_activeTabIndex == 0)
              IconButton(
                icon: _alreadySavedGameId != null
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                tooltip: _alreadySavedGameId == null
                    ? 'Salvar jogo'
                    : 'Excluir jogo salvo',
                color: Colors.white,
                onPressed: saveGameOnTap,
              )
            else if (_lotteryAPIResult != null)
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Compartilhar resultado',
                color: Colors.white,
                onPressed: () async {
                  Share.share(_lotteryAPIResult!.shareString());
                  await FirebaseAnalytics.instance.logShare(
                      contentType: _lotteryAPIResult!.name!,
                      itemId: _lotteryAPIResult!.contestNumber!.toString(),
                      method: 'app');
                },
              ),
          ],
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabGenerateGuess(widget.contest,
                      notifyParent: _updateUI,
                      generatedGameResolver: _resolveGeneratedGame),
                  TabResult(widget.contest, refreshResult),
                ],
              ),
            ),
            AdMobService.getBannerAdWidget(_bannerAd),
          ],
        ),
      ),
    );
  }

  void saveGameOnTap() async {
    SnackBar snackBar;
    if (_alreadySavedGameId != null) {
      _savedGameService.deleteSavedGameById(_alreadySavedGameId!);
      _alreadySavedGameId = null;
      snackBar = _getDeletedGameSnackBar();
    } else {
      _alreadySavedGameId = await _savedGameService.createOrUpdateSavedGame(
        SavedGame(contestId: widget.contest.id, numbers: _generatedGame),
      );
      snackBar = _getSavedGameSnackBar();
    }
    _updateUI(_alreadySavedGameId);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _resolveGeneratedGame(String generatedGame) {
    _generatedGame = generatedGame;
  }

  Future<void> _updateUI(int? alreadySavedGameId) async {
    _alreadySavedGameId = alreadySavedGameId;
    setState(() {});
  }

  SnackBar _getSavedGameSnackBar() {
    return SnackBar(
      content: const Text('Jogo salvo com sucesso'),
      action: SnackBarAction(
        label: 'Ver',
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => MySavedGames(
                initPositionContest: widget.contest,
                initPositionGameId: _alreadySavedGameId,
              ),
            ),
          );
        },
      ),
    );
  }

  SnackBar _getDeletedGameSnackBar() {
    return SnackBar(
      content: const Text('Jogo excluído'),
      action: SnackBarAction(
        label: 'Dezfazer',
        onPressed: saveGameOnTap,
      ),
    );
  }
}
