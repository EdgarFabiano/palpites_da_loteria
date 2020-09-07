
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
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
    var defaultTableBorder = BorderSide(
      color: Colors.black,
      style: BorderStyle.solid,
      width: 0.2,
    );

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Flex(
        direction: Axis.vertical,
        children: _getResultChildren(context, defaultTableBorder),
      ),
    );
  }

  _getResultChildren(BuildContext context, BorderSide defaultTableBorder) {
    List <Widget> builder = [];

    if (widget.resultado.acumulou != null) {
      builder.add(Text(widget.resultado.acumulou ? "ACUMULOU!" : "TEVE GANHADOR", style: TextStyle(fontSize: 25),));
    }

    builder.add(Divider(indent: 50, endIndent: 50,));

    if (widget.resultado.numero_concurso != null && widget.resultado.data_concurso != null) {
      builder.add(    Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("Concurso: " + widget.resultado.numero_concurso.toString()),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("Data: " +
                formatDate(DateTime.parse(widget.resultado.data_concurso),
                    [dd, '/', mm, '/', yyyy]).toString()),
          )
        ],
      ));
    }
    if (widget.resultado.dezenas != null && widget.resultado.dezenas.isNotEmpty) {
      builder.add(Card(
        elevation: 2,
        color: widget.concursoBean.colorBean.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(_getDezenasResultadoDisplayValue(widget.resultado.dezenas),
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              )),
        ),
      ));
    }

    if (widget.resultado.dezenas_2 != null && widget.resultado.dezenas_2.isNotEmpty) {
      builder.add(Card(
        elevation: 2,
        color: widget.concursoBean.colorBean.getColor(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(_getDezenasResultadoDisplayValue(widget.resultado.dezenas_2),
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              )),
        ),
      ));
    }

    if (widget.resultado.local_realizacao != null && widget.resultado.local_realizacao != "") {
      builder.add(Padding(
        padding: EdgeInsets.all(15),
        child: Text("Local de realização: " + widget.resultado.local_realizacao),
      ));
    }

    if (!widget.resultado.acumulou) {
      builder.add(Table(
        border: TableBorder(
          bottom: defaultTableBorder,
          horizontalInside: defaultTableBorder,
        ),
        children: _criarTabelaPremiacao(widget.resultado.premiacao),
      ));
    }

    return builder;
  }

  _criarTabelaPremiacao(List<Premiacao> premiacao) {
    var cabecalho = _criarCabecalhoTable("Acertos, Ganhadores, Premiação");
    var list = premiacao.map((e) {
      return TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            e.acertos.toString(),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            e.quantidade_ganhadores.toString(),
          ),
          padding: EdgeInsets.all(10.0),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(NumberFormat.compactLong(locale: 'pt_BR',).format(e.valor_total)),
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
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10))),
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
