import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palpites_da_loteria/model/model-export.dart';
import 'package:palpites_da_loteria/service/loteria-api-service.dart';
import 'package:provider/provider.dart';

import 'internet_not_available.dart';

DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
Options _cacheOptions = buildCacheOptions(Duration(days: 7), forceRefresh: true);
Dio _dio = Dio();

Resultado parseResultado(Map<String, dynamic> responseBody) {
  return Resultado.fromJson(responseBody);
}

Future<Resultado> fetchResultado(String concursoName) async {
  var url = LoteriaAPIService.getEndpointFor(concursoName);
  Response response = await _dio.get(url, options: _cacheOptions);

  if (response.statusCode == 200 && response.data is Map) {
    return compute(parseResultado, response.data as Map<String, dynamic>);
  } else {
    return Future.value(Resultado());
  }
}

class TabResultado extends StatefulWidget {
  final ConcursoBean concursoBean;
  const TabResultado(this.concursoBean, {Key key}) : super(key: key);

  @override
  _TabResultadoState createState() => _TabResultadoState();
}

class _TabResultadoState extends State<TabResultado> with AutomaticKeepAliveClientMixin {
  Future<Resultado> futureResultado;

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(_dioCacheManager.interceptor);
    futureResultado = fetchResultado(widget.concursoBean.name);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Visibility(
            visible: Provider.of<DataConnectionStatus>(context) ==
                DataConnectionStatus.disconnected,
            child: InternetNotAvailable()),
        FutureBuilder<Resultado>(
          future: futureResultado,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Flexible(
                child: ListView(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 35),
                  children: _getResultadoWidgets(snapshot.data, context),
                ),
              );
            } else if (snapshot.hasError) {
              return Expanded(child: Center(child: Icon(Icons.signal_wifi_off)));
            }
            return Expanded(child: Center(child: CircularProgressIndicator()));
          },
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
            child: Text("Data: " + _formatDate(resultado.data_concurso)),
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
            child: Text(_getDezenasResultadoDisplayValue(resultado.dezenas),
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
            child: Text(_getDezenasResultadoDisplayValue(resultado.dezenas_2),
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
                        _formatCurrency(resultado.arrecadacao_total),
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
                        _formatCurrency(resultado.valor_acumulado),
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
          _formatCurrency(resultado.valor_estimado_proximo_concurso) + '!',
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
        proxConcurso.add(Text(_formatDate(resultado.data_proximo_concurso)));
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
        resultado.valor_acumulado_especial != null) {

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
            _formatCurrency(resultado.valor_acumulado_especial) + '!',
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

  _getDezenasResultadoDisplayValue(List<String> resultado) {
    var value = "";
    if (resultado.length <= 7) {
      resultado.forEach((element) {
        value += value == "" ? element : " | " + element;
      });
    } else {
      var count = 0;
      var iterator = resultado.iterator;
      resultado.forEach((element) {
        value += value == "" || value.endsWith("\n") ? element : " | " + element;
        count++;
        if (count >= 5) {
          count = 0;
          value += !iterator.moveNext() ? "" : "\n";
        }
      });
      value = value.substring(0, value.length-1);
    }
    return value;
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
            _formatNumber(premiacaoItem.quantidade_ganhadores),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(_formatCurrency(premiacaoItem.valor_total)),
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
          child: Text(_formatNumber(localGanhador.quantidade_ganhadores)),
          padding: EdgeInsets.all(10.0),
        )
      ]);
    }).toList();

    list.insert(0, cabecalho);
    return list;
  }

  String _formatDate(String date) {
    return formatDate(DateTime.parse(date), [dd, '/', mm, '/', yyyy])
        .toString();
  }

  String _formatNumber(dynamic valor) {
    return NumberFormat.decimalPattern('pt_BR').format(valor);
  }

  String _formatCurrency(dynamic valor) {
    return 'R\$ ' + NumberFormat.compactLong(locale: 'pt_BR').format(valor);
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
}
