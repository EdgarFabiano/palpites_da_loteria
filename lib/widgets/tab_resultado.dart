import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/loteria_api_service.dart';
import 'package:palpites_da_loteria/widgets/internet_not_available.dart';

import '../model/resultado_api.dart';

class TabResultado extends StatefulWidget {
  final ConcursoBean concursoBean;
  final Function refreshResultadoCompartilhavel;

  const TabResultado(this.concursoBean, this.refreshResultadoCompartilhavel,
      {Key? key})
      : super(key: key);

  @override
  _TabResultadoState createState() => _TabResultadoState();
}

class _TabResultadoState extends State<TabResultado>
    with AutomaticKeepAliveClientMixin {
  Future<ResultadoAPI>? _futureResultado;
  final _concursoTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _ultimoConcurso = 0;
  int _concursoAtual = 0;
  LoteriaAPIService _loteriaAPIService = LoteriaAPIService();

  Future<void> _showDialogConcurso() async {
    _concursoTextController.text = _concursoAtual.toString();
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
                    controller: _concursoTextController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!RegExp('[0-9]').hasMatch(value!)) {
                        return "Valor inválido";
                      } else if (int.parse(value) > _ultimoConcurso) {
                        return "Valor máximo: $_ultimoConcurso";
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Buscar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _concursoAtual = int.parse(_concursoTextController.text);
                  if (_concursoAtual > _ultimoConcurso)
                    _concursoAtual = _ultimoConcurso;
                  setState(() {
                    _futureResultado = _loteriaAPIService.fetchResultado(
                        widget.concursoBean, _concursoAtual);
                    widget.refreshResultadoCompartilhavel(_concursoAtual);
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

  @override
  void initState() {
    super.initState();
    _futureResultado = _loteriaAPIService
        .fetchLatestResultado(widget.concursoBean)
        .then((value) {
      setState(() {
        _ultimoConcurso = value.concurso!;
        _concursoAtual = value.concurso!;
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
    _concursoTextController.dispose();
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
        !isDisconnected && _concursoAtual != 0
            ? _getButtonsTop()
            : SizedBox.shrink(),
        Expanded(
          child: FutureBuilder<ResultadoAPI>(
            future: _futureResultado,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                ResultadoAPI resultado = snapshot.data!;
                return Column(
                  children: [
                    !isDisconnected ? Divider(height: 0) : SizedBox.shrink(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 35),
                        children: _getResultadoWidgets(resultado, context),
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

  _getResultadoWidgets(ResultadoAPI resultado, BuildContext context) {
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
          resultado.acumulou ? "ACUMULOU!" : "TEVE GANHADOR",
          style: TextStyle(fontSize: 25),
        ),
      ),
    ));

    builder.add(Divider(
      indent: 50,
      endIndent: 50,
    ));

    if (resultado.concurso != null && resultado.data != null) {
      builder.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Concurso: " + resultado.concurso.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Data: " + resultado.getDataConcursoDisplayValue()),
          )
        ],
      ));
    }

    if (resultado.dezenas != null && resultado.dezenas!.isNotEmpty) {
      builder.add(Card(
        color: widget.concursoBean.colorBean.getColor(context),
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

    if (resultado.timeCoracaoOuMesSorte != null &&
        resultado.timeCoracaoOuMesSorte != "") {
      builder.add(Card(
        color: widget.concursoBean.colorBean.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              resultado.timeCoracaoOuMesSorte!,
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

    if (resultado.premiacoes != null && resultado.premiacoes!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaPremiacao(resultado.premiacoes!),
        ),
      ));
    }

    if (resultado.dezenas_2 != null && resultado.dezenas_2!.isNotEmpty) {
      builder.add(Card(
        color: widget.concursoBean.colorBean.getColor(context),
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

    if (resultado.premiacoes_2 != null && resultado.premiacoes_2!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaPremiacao(resultado.premiacoes_2!),
        ),
      ));
    }

    if (resultado.estadosPremiados != null &&
        resultado.estadosPremiados!.isNotEmpty) {
      builder.add(Card(
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaLocalGanhadores(resultado.estadosPremiados!),
        ),
      ));
    }

    if (resultado.local != null && resultado.local != "") {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Center(child: Text("Local de realização: " + resultado.local!)),
      ));
    }

    List<Widget> proxConcurso = [];

    if (resultado.getValorEstimadoProximoConcursoDisplayValue() != '') {
      proxConcurso.add(
        Text(
          "Prêmio estimado para o próximo concurso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      proxConcurso.add(Text(
        resultado.getValorEstimadoProximoConcursoDisplayValue(),
      ));
    }

    if ((resultado.getValorEstimadoProximoConcursoDisplayValue() != '') &&
        (resultado.getDataProximoConcursoDisplayValue() != '')) {
      proxConcurso.add(Divider());
    }

    if (resultado.getDataProximoConcursoDisplayValue() != '') {
      proxConcurso.add(Text(
        "Data do próximo concurso",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
      proxConcurso.add(Text(resultado.getDataProximoConcursoDisplayValue()));
    }

    if ((resultado.getValorEstimadoProximoConcursoDisplayValue() != '') &&
        (resultado.getDataProximoConcursoDisplayValue() != '')) {
      builder.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: proxConcurso,
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
          visible: _concursoAtual > 1,
          child: FlatButton(
              onPressed: () => setState(() {
                    --_concursoAtual;
                    _futureResultado = _loteriaAPIService.fetchResultado(
                        widget.concursoBean, _concursoAtual);
                    widget.refreshResultadoCompartilhavel(_concursoAtual);
                  }),
              child: Text("Anterior")),
        ),
        FlatButton(
          onPressed: _showDialogConcurso,
          child: Text(
            _concursoAtual.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _concursoAtual < _ultimoConcurso,
          child: FlatButton(
              onPressed: () => setState(() {
                    ++_concursoAtual;
                    _futureResultado = _loteriaAPIService.fetchResultado(
                        widget.concursoBean, _concursoAtual);
                    widget.refreshResultadoCompartilhavel(_concursoAtual);
                  }),
              child: Text("Próximo")),
        ),
      ],
    );
  }
}
