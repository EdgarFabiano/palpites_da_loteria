import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/loteria_api_service.dart';
import 'package:palpites_da_loteria/widgets/internet_not_available.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
Options _cacheOptions =
    buildCacheOptions(Duration(minutes: 5), forceRefresh: true);
Dio _dio = Dio();

Resultado parseResultado(Map<String, dynamic> responseBody) {
  return Resultado.fromJson(responseBody);
}

Future<Resultado> fetchResultado(String concursoName, int concurso) async {
  var url =
      LoteriaAPIService.getEndpointFor(concursoName) + "&concurso=${concurso}";
  Response response = await _dio.get(url, options: _cacheOptions);
  if (response.statusCode == 200 && response.data is Map) {
    return compute(parseResultado, response.data as Map<String, dynamic>);
  } else {
    return Future.value(Resultado());
  }
}

bool await(Duration duration) {
  sleep(duration);
  return true;
}

Future<bool> futureAwait() {
  return compute(await, Duration(seconds: 0));
}

class TabResultado extends StatefulWidget {
  final ConcursoBean concursoBean;

  const TabResultado(this.concursoBean, {Key key}) : super(key: key);

  @override
  _TabResultadoState createState() => _TabResultadoState();
}

class _TabResultadoState extends State<TabResultado>
    with AutomaticKeepAliveClientMixin {
  Future<Resultado> _futureResultado;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final _concursoTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _ultimoConcurso;
  int _concursoAtual;
  var interstitialAd = AdMobService.buildResultadoInterstitial();

  Future<void> _showDialogConcurso() async {
    _concursoTextController.text = _concursoAtual?.toString();
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
                      if (!RegExp('[0-9]').hasMatch(value)) {
                        return "Valor inválido";
                      } else if (int.parse(value) > _ultimoConcurso) {
                        return "Valor máximo: ${_ultimoConcurso}";
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
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Buscar'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _concursoAtual = int.parse(_concursoTextController.text);
                  _futureResultado =
                      fetchResultado(widget.concursoBean.name, _concursoAtual);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onRefresh() async {
    setState(() {
      _futureResultado =
          fetchResultado(widget.concursoBean.name, _ultimoConcurso)
              .whenComplete(() => _refreshController.refreshCompleted())
              .whenComplete(() => _concursoAtual = _ultimoConcurso);
    });
  }

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(_dioCacheManager.interceptor);
    _futureResultado = fetchResultado(widget.concursoBean.name, _concursoAtual);
    futureAwait().whenComplete(() {
      return interstitialAd
        ..load()
        ..show();
    });
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    _concursoTextController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var isDisconnected = Provider.of<DataConnectionStatus>(context) ==
        DataConnectionStatus.disconnected;

    return Column(
      children: [
        isDisconnected ? InternetNotAvailable() : SizedBox.shrink(),
        Expanded(
          child: FutureBuilder<Resultado>(
            future: _futureResultado,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                var resultado = snapshot.data;
                if (_ultimoConcurso == null) {
                  _ultimoConcurso = resultado.numero_concurso;
                }
                if (_concursoAtual == null) {
                  _concursoAtual = _ultimoConcurso;
                }
                return Column(
                  children: [
                    !isDisconnected ? _getButtonsTop() : SizedBox.shrink(),
                    !isDisconnected ? Divider(height: 0) : SizedBox.shrink(),
                    Expanded(
                      child: SmartRefresher(
                        enablePullDown: !isDisconnected,
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: ListView(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 35),
                          children: _getResultadoWidgets(resultado, context),
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return SmartRefresher(
                  enablePullDown: !isDisconnected,
                  onRefresh: _onRefresh,
                  controller: _refreshController,
                  child: Column(
                    children: [
                      Expanded(
                          child: Center(child: Icon(Icons.signal_wifi_off))),
                    ],
                  ),
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

  _getResultadoWidgets(Resultado resultado, BuildContext context) {
    List<Widget> builder = [];

    var defaultTableBorder = BorderSide(
      color: Colors.black,
      style: BorderStyle.solid,
      width: 0.2,
    );

    if (resultado.acumulou != null) {
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
    }

    if (resultado.numero_concurso != null && resultado.data_concurso != null) {
      builder.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Concurso: " + resultado.numero_concurso.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Data: " + resultado.getDataConcursoDisplayValue()),
          )
        ],
      ));
    }

    if (resultado.dezenas != null && resultado.dezenas.isNotEmpty) {
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

    if (resultado.dezenas_2 != null && resultado.dezenas_2.isNotEmpty) {
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

    if (resultado.local_realizacao != null &&
        resultado.local_realizacao != "") {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
            child: Text("Local de realização: " + resultado.local_realizacao)),
      ));
    }

    if (resultado.arrecadacao_total != null &&
        resultado.valor_acumulado != null) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Arrecadação total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        resultado.getArrecadacaoTotalDisplayValue(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Acumulado",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        resultado.getValorAcumuladoDisplayValue(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ));
    }

    if ((resultado.valor_estimado_proximo_concurso != null &&
        resultado.valor_estimado_proximo_concurso != 0) ||
        (resultado.data_proximo_concurso != null &&
            resultado.data_proximo_concurso != '')) {
      List<Widget> proxConcurso = [];

      if (resultado.valor_estimado_proximo_concurso != null &&
          resultado.valor_estimado_proximo_concurso != 0) {
        proxConcurso.add(
          Text(
            "Prêmio estimado para o próximo concurso",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        proxConcurso.add(Text(
          resultado.getValorEstimadoProximoConcursoDisplayValue() + '!',
        ));
      }

      if ((resultado.valor_estimado_proximo_concurso != null &&
          resultado.valor_estimado_proximo_concurso != 0) &&
          (resultado.data_proximo_concurso != null &&
              resultado.data_proximo_concurso != '')) {
        proxConcurso.add(Divider());
      }

      if (resultado.data_proximo_concurso != null &&
          resultado.data_proximo_concurso != '') {
        proxConcurso.add(Text(
          "Data do próximo concurso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
        proxConcurso.add(Text(resultado.getDataProximoConcursoDisplayValue()));
      }

      builder.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: proxConcurso,
          ),
        ),
      ));
    }

    if (resultado.nome_acumulado_especial != null &&
        resultado.nome_acumulado_especial != '' &&
        resultado.valor_acumulado_especial != null &&
        resultado.valor_acumulado_especial != 0) {
      builder.add(
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Center(
            child: Text(
              "Acumulado  '${resultado.nome_acumulado_especial}'",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      builder.add(Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Text(
            resultado.getValorAcumuladoEspecialDisplayValue() + '!',
          ),
        ),
      ));
    }

    if (resultado.premiacao != null && resultado.premiacao.isNotEmpty) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Card(
          child: Table(
            border: TableBorder(
              bottom: defaultTableBorder,
              horizontalInside: defaultTableBorder,
            ),
            children: _criarTabelaPremiacao(resultado.premiacao),
          ),
        ),
      ));
    }

    if (resultado.local_ganhadores != null &&
        resultado.local_ganhadores.isNotEmpty) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Card(
          child: Table(
            border: TableBorder(
              bottom: defaultTableBorder,
              horizontalInside: defaultTableBorder,
            ),
            children: _criarTabelaLocalGanhadores(resultado.local_ganhadores),
          ),
        ),
      ));
    }

    return builder;
  }

  _criarTabelaPremiacao(List<Premiacao> premiacao) {
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
            premiacaoItem.getQuantidadeGanhadoresDisplayValue(),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(premiacaoItem.getValorTotalDisplayValue()),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, cabecalho);
    return list;
  }

  _criarTabelaLocalGanhadores(List<LocalGanhador> premiacao) {
    var cabecalho = _criarCabecalhoTable("Local, Ganhadores");
    var list = premiacao.map((localGanhador) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            localGanhador.local,
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(localGanhador.getQuantidadeGanhadoresDisplayValue()),
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
          visible: _concursoAtual != null && _concursoAtual > 1,
          child: FlatButton(
              onPressed: () =>
                  setState(() {
                    --_concursoAtual;
                    _futureResultado = fetchResultado(
                        widget.concursoBean.name, _concursoAtual);
                  }),
              child: Text("Anterior")),
        ),
        FlatButton(
          onPressed: _showDialogConcurso,
          child: Text(
            _concursoAtual != null ? _concursoAtual.toString() : "----",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _concursoAtual != null && _concursoAtual < _ultimoConcurso,
          child: FlatButton(
              onPressed: () =>
                  setState(() {
                    ++_concursoAtual;
                    _futureResultado = fetchResultado(
                        widget.concursoBean.name, _concursoAtual);
                  }),
              child: Text("Próximo")),
        ),
      ],
    );
  }
}
