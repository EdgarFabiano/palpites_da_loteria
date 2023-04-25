import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/lottery_api_service.dart';
import 'package:palpites_da_loteria/widgets/internet_not_available.dart';

import '../defaults/themes.dart';

class TabResultado extends StatefulWidget {
  final Contest _contest;
  final Function refreshResultado;

  const TabResultado(this._contest, this.refreshResultado, {Key? key})
      : super(key: key);

  @override
  _TabResultadoState createState() => _TabResultadoState();
}

class _TabResultadoState extends State<TabResultado>
    with AutomaticKeepAliveClientMixin {
  Future<LotteryAPIResult>? _futureResultado;
  LotteryAPIResult? _resultadoAPI;
  final _contestTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _lastContest = 0;
  int _currentContest = 0;
  LotteryAPIService _loteriaAPIService = LotteryAPIService();

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
                    _refreshResultado();
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

  void _refreshResultado() {
    widget.refreshResultado(null);
    _futureResultado = _loteriaAPIService
        .fetchResultado(widget._contest, _currentContest)
        .then((value) {
      widget.refreshResultado(value);
      return Future.value(value);
    });
  }

  @override
  void initState() {
    super.initState();
    _futureResultado = _loteriaAPIService
        .fetchLatestResultado(widget._contest)
        .then((value) {
      widget.refreshResultado(value);
      setState(() {
        _lastContest = value.contestNumber!;
        _currentContest = value.contestNumber!;
      });
      return Future.value(value);
    });
    if (Random().nextInt(10) > 4) {
      AdMobService.createResultadoInterstitialAd();
      AdMobService.showResultadoInterstitialAd();
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
            future: _futureResultado,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                _resultadoAPI = snapshot.data!;
                // widget.refreshResultado(_resultadoAPI);
                return Column(
                  children: [
                    !isDisconnected ? Divider(height: 0) : SizedBox.shrink(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 35),
                        children: _getResultadoWidgets(_resultadoAPI!, context),
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

  _getResultadoWidgets(LotteryAPIResult resultado, BuildContext context) {
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
          resultado.accumulated ? "ACUMULOU!" : "TEVE GANHADOR",
          style: TextStyle(fontSize: 25),
        ),
      ),
    ));

    builder.add(Divider(
      indent: 50,
      endIndent: 50,
    ));

    if (resultado.contestNumber != null && resultado.date != null) {
      builder.add(Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Concurso: " + resultado.contestNumber.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Data: " + resultado.getContestDataDisplayValue()),
          )
        ],
      ));
    }

    if (resultado.numbers != null && resultado.numbers!.isNotEmpty) {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(resultado.getDezenasDisplayValue(),
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                )),
          ),
        ),
      ));
    }

    if (resultado.teamOfTheHeartOrLuckyMonth != null &&
        resultado.teamOfTheHeartOrLuckyMonth != "") {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              resultado.teamOfTheHeartOrLuckyMonth!,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    // if (resultado.arrecadacao_total != null &&
    //     resultado.valor_acumulado != null) {
    //   builder.add(Padding(
    //     padding: EdgeInsets.only(top: 10.0),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Card(
    //             child: Padding(
    //               padding: const EdgeInsets.all(10.0),
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     "Arrecadação total",
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   Divider(),
    //                   Text(
    //                     resultado.getArrecadacaoTotalDisplayValue(),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Card(
    //             child: Padding(
    //               padding: const EdgeInsets.all(10.0),
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     "Acumulado",
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   Divider(),
    //                   Text(
    //                     resultado.getValorAcumuladoDisplayValue(),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ));
    // }

    // if (resultado.nome_acumulado_especial != null &&
    //     resultado.nome_acumulado_especial != '' &&
    //     resultado.valor_acumulado_especial != null &&
    //     resultado.valor_acumulado_especial != 0) {
    //   builder.add(
    //     Padding(
    //       padding: const EdgeInsets.only(top: 10.0),
    //       child: Center(
    //         child: Text(
    //           "Acumulado  '${resultado.nome_acumulado_especial}'",
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    //   builder.add(Padding(
    //     padding: EdgeInsets.only(top: 8.0),
    //     child: Center(
    //       child: Text(
    //         resultado.getValorAcumuladoEspecialDisplayValue() + '!',
    //       ),
    //     ),
    //   ));
    // }

    if (resultado.prizes != null && resultado.prizes!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaPremiacao(resultado.prizes!),
        ),
      ));
    }

    if (resultado.numbers_2 != null && resultado.numbers_2!.isNotEmpty) {
      builder.add(Card(
        color: widget._contest.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(resultado.getDezenas2DisplayValue(),
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                )),
          ),
        ),
      ));
    }

    if (resultado.prizes_2 != null && resultado.prizes_2!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaPremiacao(resultado.prizes_2!),
        ),
      ));
    }

    if (resultado.winningEstates != null &&
        resultado.winningEstates!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaLocalGanhadores(resultado.winningEstates!),
        ),
      ));
    }

    if (resultado.place != null && resultado.place != "") {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Center(child: Text("Local de realização: " + resultado.place!)),
      ));
    }

    List<Widget> nextContest = [];

    if (resultado.getNextContestEstimatedPrizeDisplayValue() != '') {
      nextContest.add(
        Text(
          "Prêmio estimado para o próximo concurso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      nextContest.add(Text(
        resultado.getNextContestEstimatedPrizeDisplayValue(),
      ));
    }

    if ((resultado.getNextContestEstimatedPrizeDisplayValue() != '') &&
        (resultado.getNextContestDateDisplayValue() != '')) {
      nextContest.add(Divider());
    }

    if (resultado.getNextContestDateDisplayValue() != '') {
      nextContest.add(Text(
        "Data do próximo concurso",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
      nextContest.add(Text(resultado.getNextContestDateDisplayValue()));
    }

    if ((resultado.getNextContestEstimatedPrizeDisplayValue() != '') &&
        (resultado.getNextContestDateDisplayValue() != '')) {
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

  _criarTabelaPremiacao(List<Premiacoes> premiacao) {
    var cabecalho = _criarCabecalhoTable("Acertos, Ganhadores, Premiação");
    var list = premiacao.map((premiacaoItem) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            premiacaoItem.acertos.toString(),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            premiacaoItem.vencedores!,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text("${premiacaoItem.premio!}"),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, cabecalho);
    return list;
  }

  _criarTabelaLocalGanhadores(List<EstadosPremiados> premiacao) {
    var cabecalho = _criarCabecalhoTable("Local, Ganhadores");
    var list = premiacao.map((localGanhador) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            localGanhador.nome! + " - " + localGanhador.uf!,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(localGanhador.vencedores!),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, cabecalho);
    return list;
  }

  _criarCabecalhoTable(String listaNomes) {
    return TableRow(
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      children: listaNomes.split(',').map((name) {
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
              _refreshResultado();
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
              _refreshResultado();
            }),
            child: Text("Próximo"),
            style: DefaultThemes.flatButtonStyle(context),
          ),
        ),
      ],
    );
  }
}
