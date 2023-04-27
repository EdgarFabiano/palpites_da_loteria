import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/lottery_api_service.dart';
import 'package:palpites_da_loteria/widgets/internet_not_available.dart';

import '../defaults/themes.dart';

class TabResult extends StatefulWidget {
  final Contest _contest;
  final Function refreshResult;

  const TabResult(this._contest, this.refreshResult, {Key? key})
      : super(key: key);

  @override
  _TabResultState createState() => _TabResultState();
}

class _TabResultState extends State<TabResult>
    with AutomaticKeepAliveClientMixin {
  Future<LotteryAPIResult>? _futureResult;
  LotteryAPIResult? _lotteryApiResult;
  final _contestTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _lastContest = 0;
  int _currentContest = 0;
  LotteryAPIService _lotteryAPIService = LotteryAPIService();

  Future<void> _showDialogContest() async {
    _contestTextController.text = _currentContest.toString();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Número do concurso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Digite o número do concurso que deseja buscar'),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _contestTextController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!RegExp('[0-9]').hasMatch(value!)) {
                        return "Valor inválido";
                      } else if (int.parse(value) > _lastContest) {
                        return "Valor máximo: $_lastContest";
                      } else if (int.parse(value) < 1) {
                        return "Valor mínimo: 1";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              style: DefaultThemes.flatButtonStyle(context),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Buscar'),
              style: DefaultThemes.flatButtonStyle(context),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _currentContest = int.parse(_contestTextController.text);
                  if (_currentContest > _lastContest)
                    _currentContest = _lastContest;
                  setState(() {
                    _refreshResult();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _refreshResult() {
    widget.refreshResult(null);
    _futureResult = _lotteryAPIService
        .fetchResult(widget._contest, _currentContest)
        .then((value) {
      widget.refreshResult(value);
      return Future.value(value);
    });
  }

  @override
  void initState() {
    super.initState();
    _futureResult =
        _lotteryAPIService.fetchLatestResult(widget._contest).then((value) {
      widget.refreshResult(value);
      setState(() {
        _lastContest = value.contestNumber!;
        _currentContest = value.contestNumber!;
      });
      return Future.value(value);
    });
    if (Random().nextInt(10) > 4) {
      AdMobService.createResultInterstitialAd();
      AdMobService.showResultInterstitialAd();
    }
  }

  @override
  void dispose() {
    _contestTextController.dispose();
    super.dispose();
  }

  Future<bool> _isDisconnected() async {
    return !await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isDisconnected = false;
    _isDisconnected().then((value) => isDisconnected = value);

    return Column(
      children: [
        isDisconnected ? InternetNotAvailable() : SizedBox.shrink(),
        !isDisconnected && _currentContest != 0
            ? _getButtonsTop()
            : SizedBox.shrink(),
        Expanded(
          child: FutureBuilder<LotteryAPIResult>(
            future: _futureResult,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                _lotteryApiResult = snapshot.data!;
                return Column(
                  children: [
                    !isDisconnected ? Divider(height: 0) : SizedBox.shrink(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 35),
                        children: _getLotteryAPIResultWidgets(_lotteryApiResult!, context),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Expanded(child: Center(child: Icon(Icons.signal_wifi_off))),
                  ],
                );
              }
              return Column(
                children: [
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  _getLotteryAPIResultWidgets(LotteryAPIResult result, BuildContext context) {
    List<Widget> builder = [];

    var defaultTableBorder = BorderSide(
      color: Colors.black,
      style: BorderStyle.solid,
      width: 0.2,
    );

    builder.add(Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          result.accumulated ? "ACUMULOU!" : "TEVE GANHADOR",
          style: TextStyle(fontSize: 25),
        ),
      ),
    ));

    builder.add(Divider(
      indent: 50,
      endIndent: 50,
    ));

    if (result.contestNumber != null && result.date != null) {
      builder.add(Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Concurso: " + result.contestNumber.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Data: " + result.getContestDataDisplayValue()),
          )
        ],
      ));
    }

    if (result.numbers != null && result.numbers!.isNotEmpty) {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(result.getGuessNumberDisplayValue(),
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                )),
          ),
        ),
      ));
    }

    if (result.teamOfTheHeartOrLuckyMonth != null &&
        result.teamOfTheHeartOrLuckyMonth != "") {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              result.teamOfTheHeartOrLuckyMonth!,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    if (result.prizes != null && result.prizes!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _createPrizesTable(result.prizes!),
        ),
      ));
    }

    if (result.numbers_2 != null && result.numbers_2!.isNotEmpty) {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(result.getGuessNumbers2DisplayValue(),
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                )),
          ),
        ),
      ));
    }

    if (result.prizes_2 != null && result.prizes_2!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _createPrizesTable(result.prizes_2!),
        ),
      ));
    }

    if (result.winningEstates != null &&
        result.winningEstates!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _createWinnersLocationTable(result.winningEstates!),
        ),
      ));
    }

    if (result.place != null && result.place != "") {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Center(child: Text("Local de realização: " + result.place!)),
      ));
    }

    List<Widget> nextContest = [];

    if (result.getNextContestEstimatedPrizeDisplayValue() != '') {
      nextContest.add(
        Text(
          "Prêmio estimado para o próximo concurso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      nextContest.add(Text(
        result.getNextContestEstimatedPrizeDisplayValue(),
      ));
    }

    if ((result.getNextContestEstimatedPrizeDisplayValue() != '') &&
        (result.getNextContestDateDisplayValue() != '')) {
      nextContest.add(Divider());
    }

    if (result.getNextContestDateDisplayValue() != '') {
      nextContest.add(Text(
        "Data do próximo concurso",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
      nextContest.add(Text(result.getNextContestDateDisplayValue()));
    }

    if ((result.getNextContestEstimatedPrizeDisplayValue() != '') &&
        (result.getNextContestDateDisplayValue() != '')) {
      builder.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: nextContest,
          ),
        ),
      ));
    }

    return builder;
  }

  _createPrizesTable(List<Prizes> prize) {
    var header = _createTableHeader("Acertos, Ganhadores, Premiação");
    var list = prize.map((headerItem) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            headerItem.acertos.toString(),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            headerItem.vencedores!,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text("${headerItem.premio!}"),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, header);
    return list;
  }

  _createWinnersLocationTable(List<StateWithPrize> premiacao) {
    var header = _createTableHeader("Local, Ganhadores");
    var list = premiacao.map((winningState) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            winningState.nome! + " - " + winningState.uf!,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(winningState.vencedores!),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, header);
    return list;
  }

  _createTableHeader(String namesList) {
    return TableRow(
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      children: namesList.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            name,
          ),
          padding: EdgeInsets.all(10.0),
        );
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _getButtonsTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _currentContest > 1,
          child: TextButton(
            onPressed: () => setState(() {
              --_currentContest;
              _refreshResult();
            }),
            child: Text("Anterior"),
            style: DefaultThemes.flatButtonStyle(context),
          ),
        ),
        TextButton(
          onPressed: _showDialogContest,
          child: Text(
            _currentContest.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: DefaultThemes.flatButtonStyle(context),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _currentContest < _lastContest,
          child: TextButton(
            onPressed: () => setState(() {
              ++_currentContest;
              _refreshResult();
            }),
            child: Text("Próximo"),
            style: DefaultThemes.flatButtonStyle(context),
          ),
        ),
      ],
    );
  }
}
