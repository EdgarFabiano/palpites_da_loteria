import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/domain/local-ganhador.dart';
import 'package:palpites_da_loteria/domain/premiacao.dart';
import 'package:palpites_da_loteria/domain/resultado.dart';

class TabResultado extends StatefulWidget {
  final Resultado resultado;
  final ConcursoBean concursoBean;

  TabResultado({Key key, this.resultado, this.concursoBean}) : super(key: key);

  @override
  _TabResultadoState createState() => _TabResultadoState();
}

class _TabResultadoState extends State<TabResultado> {
  _getDezenasResultadoDisplayValue(List<String> resultado) {
    var value = "";
    resultado.forEach((element) {
      value += value == "" ? element : " | " + element;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.resultado.numero_concurso == null) {
      return Padding(
        padding: EdgeInsets.all(15),
        child: Visibility(
          visible: widget.resultado.numero_concurso != null,
          child: Text("Sem conexão"),
        ),
      );
    }

    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          child: ListView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 35),
            children: _getResultadoWidgets(context),
          ),
        )
      ],
    );
  }

  _getResultadoWidgets(BuildContext context) {
    List<Widget> builder = [];

    var defaultTableBorder = BorderSide(
      color: Colors.black,
      style: BorderStyle.solid,
      width: 0.2,
    );

    if (widget.resultado.acumulou != null) {
      builder.add(Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            widget.resultado.acumulou ? "ACUMULOU!" : "TEVE GANHADOR",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ));

      builder.add(Divider(
        indent: 50,
        endIndent: 50,
      ));
    }

    if (widget.resultado.numero_concurso != null &&
        widget.resultado.data_concurso != null) {
      builder.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
                "Concurso: " + widget.resultado.numero_concurso.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("Data: " + _formatDate(widget.resultado.data_concurso)),
          )
        ],
      ));
    }

    if (widget.resultado.dezenas != null &&
        widget.resultado.dezenas.isNotEmpty) {
      builder.add(Card(
        elevation: 2,
        color: widget.concursoBean.colorBean.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child:
                Text(_getDezenasResultadoDisplayValue(widget.resultado.dezenas),
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    )),
          ),
        ),
      ));
    }

    if (widget.resultado.dezenas_2 != null &&
        widget.resultado.dezenas_2.isNotEmpty) {
      builder.add(Card(
        elevation: 2,
        color: widget.concursoBean.colorBean.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child:
              Text(_getDezenasResultadoDisplayValue(widget.resultado.dezenas_2),
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                  )),
        ),
      ));
    }

    if (widget.resultado.local_realizacao != null &&
        widget.resultado.local_realizacao != "") {
      builder.add(Padding(
        padding: EdgeInsets.all(15),
        child: Center(
            child: Text(
                "Local de realização: " + widget.resultado.local_realizacao)),
      ));
    }

    if ((widget.resultado.valor_estimado_proximo_concurso != null &&
            widget.resultado.valor_estimado_proximo_concurso != 0) ||
        (widget.resultado.data_proximo_concurso != null &&
            widget.resultado.data_proximo_concurso != '')) {
      List<Widget> proxConcurso = [];

      if (widget.resultado.valor_estimado_proximo_concurso != null &&
          widget.resultado.valor_estimado_proximo_concurso != 0) {
        proxConcurso.add(
          Text(
            "Prêmio estimado para o próximo concurso",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        proxConcurso.add(Divider());
        proxConcurso.add(Text(
          _formatCurrency(widget.resultado.valor_estimado_proximo_concurso) +
              '!',
        ));
      }

      if ((widget.resultado.valor_estimado_proximo_concurso != null &&
              widget.resultado.valor_estimado_proximo_concurso != 0) &&
          (widget.resultado.data_proximo_concurso != null &&
              widget.resultado.data_proximo_concurso != '')) {
        proxConcurso.add(Divider());
      }

      if (widget.resultado.data_proximo_concurso != null &&
          widget.resultado.data_proximo_concurso != '') {
        proxConcurso.add(Text(
          "Data do próximo concurso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));

        proxConcurso.add(Divider());
        proxConcurso
            .add(Text(_formatDate(widget.resultado.data_proximo_concurso)));
      }

      builder.add(Card(
        elevation: 2,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: proxConcurso,
          ),
        ),
      ));
    }

    if (widget.resultado.premiacao != null &&
        widget.resultado.premiacao.isNotEmpty) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children: _criarTabelaPremiacao(widget.resultado.premiacao),
        ),
      ));
    }

    if (widget.resultado.arrecadacao_total != null &&
        widget.resultado.valor_acumulado != null) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                color: Colors.transparent,
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
                        _formatCurrency(widget.resultado.arrecadacao_total),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 2,
                color: Colors.transparent,
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
                        _formatCurrency(widget.resultado.valor_acumulado),
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

    if (widget.resultado.local_ganhadores != null &&
        widget.resultado.local_ganhadores.isNotEmpty) {
      builder.add(Padding(
        padding: EdgeInsets.only(top: 15),
        child: Table(
          border: TableBorder(
            bottom: defaultTableBorder,
            horizontalInside: defaultTableBorder,
          ),
          children:
              _criarTabelaLocalGanhadores(widget.resultado.local_ganhadores),
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
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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
}
