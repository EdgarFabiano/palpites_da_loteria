import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/widgets/tab_resultado.dart';
import 'package:palpites_da_loteria/widgets/tab_sorteio.dart';
import 'package:share_plus/share_plus.dart';

import '../defaults/constants.dart';
import '../model/loteria_banner_ad.dart';
import '../model/saved_game.dart';
import '../service/saved_game_service.dart';
import 'my_saved_games.dart';

class SorteioResultadoPage extends StatefulWidget {
  final Contest contest;

  SorteioResultadoPage(this.contest, {Key? key}) : super(key: key);

  @override
  _SorteioResultadoPageState createState() => _SorteioResultadoPageState();
}

class _SorteioResultadoPageState extends State<SorteioResultadoPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = <Tab>[
    Tab(child: Text("Sorteio")),
    Tab(child: Text("Resultado")),
  ];
  int _activeTabIndex = 0;
  TabController? _tabController;
  ResultadoAPI? _resultado;
  LoteriaBannerAd _bannerAd =
      AdMobService.getBannerAd(AdMobService.sorteioBannerId);
  SavedGameService _savedGameService = SavedGameService();
  int? _areadySavedGameId;
  String _generatedGame = '';

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController!.index;
    });
  }

  void refreshResultado(ResultadoAPI? resultadoAPI) {
    setState(() {
      _resultado = resultadoAPI;
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
                icon: _areadySavedGameId != null
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                tooltip: _areadySavedGameId == null
                    ? 'Salvar jogo'
                    : 'Excluir jogo salvo',
                color: Colors.white,
                onPressed: saveGameOnTap,
              )
            else if (_resultado != null)
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Compartilhar resultado',
                color: Colors.white,
                onPressed: () async {
                  Share.share(_resultado!.shareString());
                  await FirebaseAnalytics.instance.logShare(
                      contentType: _resultado!.nome!,
                      itemId: _resultado!.concurso!.toString(),
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
                  TabSorteio(widget.contest,
                      notifyParent: _updateUI,
                      generatedGameResolver: _resolveGeneratedGame),
                  TabResultado(widget.contest, refreshResultado),
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
    if (_areadySavedGameId != null) {
      _savedGameService.deleteSavedGameById(_areadySavedGameId!);
      _areadySavedGameId = null;
      snackBar = _getDeletedGameSnackBar();
    } else {
      _areadySavedGameId = await _savedGameService.createOrUpdateSavedGame(
        SavedGame(contestId: widget.contest.id, numbers: _generatedGame),
      );
      snackBar = _getSavedGameSnackBar();
    }
    _updateUI(_areadySavedGameId);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _resolveGeneratedGame(String generatedGame) {
    _generatedGame = generatedGame;
  }

  Future<void> _updateUI(int? areadySavedGameId) async {
    _areadySavedGameId = areadySavedGameId;
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
