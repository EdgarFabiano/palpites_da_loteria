import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/pages/saved_game_edit_page.dart';
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

  List<Contest> _contestsWithSavedGames = [];
  List<Contest> _allContests = [];
  TabController? _tabController;
  List<Tab> _tabs = [];
  int _initPosition = 0;
  Contest? _currentContest;

  List<DropdownMenuItem<int>> _dropdownItems = [];
  int _selectedValue = 0;

  _initDropDownItems() async {
    _contestService.getActiveContests().then((value) {
      _dropdownItems = value
          .map((c) => DropdownMenuItem(child: Text(c.name), value: c.id))
          .toList();
      _selectedValue = value[0].id;
      _allContests = value;
    });
  }

  Future<bool> _asyncInit() async {
    _contestsWithSavedGames = await _contestService.getContestsWithSavedGames();
    if (_currentContest != null) {
      _initPosition = _contestsWithSavedGames.indexOf(_currentContest!);
      if (_initPosition < 0) {
        _initPosition = 0;
        _currentContest = null;
      }
    }
    _tabs =
        _contestsWithSavedGames.map((e) => Tab(child: Text(e.name))).toList();
    if (_tabController == null) {
      _tabController = TabController(vsync: this, length: _tabs.length);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _currentContest = widget.initPositionContest;
    if (Constants.showAds) {
      _bannerAd.load();
    }
    _initDropDownItems();
  }

  @override
  Widget build(BuildContext context) {
    var body = Center();
    return Center(
      child: FutureBuilder<bool>(
        future: _asyncInit(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            body = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (_contestsWithSavedGames.isEmpty) {
              body = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nenhum jogo salvo"),
                    ElevatedButton(
                      child: Text('Adicionar novo'),
                      onPressed: _showDialogNew,
                    ),
                  ],
                ),
              );
            } else {
              body = Center(
                child: Column(
                  children: [
                    Expanded(
                      child: CustomTabView(
                        initPosition: _initPosition,
                        itemCount: _contestsWithSavedGames.length,
                        colorBuilder: (context, index) =>
                            _contestsWithSavedGames[index].getColor(context),
                        tabBuilder: (context, index) =>
                            Tab(text: _contestsWithSavedGames[index].name),
                        pageBuilder: (context, index) => MySavedGamesTabItem(
                            contest: _contestsWithSavedGames[index],
                            notifyParent: _updateUI),
                        onPositionChange: (index) {
                          _initPosition = index;
                          _currentContest = _contestsWithSavedGames[index];
                        },
                      ),
                    ),
                    AdMobService.getBannerAdWidget(_bannerAd),
                  ],
                ),
              );
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(Strings.mySavedGames),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _showDialogNew,
                )
              ],
            ),
            body: body,
          );
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
    if (wasDeleted) _currentContest = null;
    setState(() {});
  }

  void _showDialogNew() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text("Selecione o concurso"),
            content: DropdownButton(
              value: _selectedValue,
              items: _dropdownItems,
              onChanged: (int? value) {
                _selectedValue = value!;
                setStateDialog(() {});
              },
              isExpanded: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (BuildContext context) {
                          var contest = _allContests
                              .where((element) => element.id == _selectedValue)
                              .first;
                          _currentContest = contest;
                          return SavedGameEditPage(
                            contest,
                            SavedGame.empty(contest.id),
                            () => _updateUI(false),
                          );
                        },
                        fullscreenDialog: true),
                  );
                },
                child: Text("Próximo"),
              ),
            ],
          ),
        );
      },
    );
    _updateUI(false);
  }
}
