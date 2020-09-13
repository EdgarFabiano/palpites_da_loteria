
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/domain/resultado.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/service/loteria-api-service.dart';
import 'package:palpites_da_loteria/widgets/popup-menu.dart';
import 'package:palpites_da_loteria/widgets/tab-resultado.dart';
import 'package:palpites_da_loteria/widgets/tab-sorteio.dart';

Resultado parseResultado (String responseBody) {
  return Resultado.fromJson(json.decode(responseBody));
}

Future<Resultado> fetchResultado(String concursoName) async {
  var url = LoteriaAPIService.getEndpointFor(concursoName);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return compute(parseResultado, response.body);
  } else {
    return Future.value(Resultado());
  }

}

class SorteioPage extends StatefulWidget {
  final ConcursoBean _concurso;

  SorteioPage(this._concurso, {Key key}) : super(key: key);

  @override
  _SorteioPageState createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {

  Future<Resultado> futureResultado;

  @override
  void initState() {
    super.initState();
    futureResultado = compute(fetchResultado, widget._concurso.name);
  }

  @override
  Widget build(BuildContext context) {

    var tabSorteio = TabSorteio(widget._concurso);

    var tabResultado = FutureBuilder<Resultado>(
      future: futureResultado,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return TabResultado(resultado: data, concursoBean: widget._concurso,);
        } else if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(15),
            child: Text("${snapshot.error}"),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );

    return Padding(
      padding: EdgeInsets.only(bottom: AdMobService.bannerPadding(context)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: widget._concurso.colorBean.getColor(context),
              bottom: TabBar(
                tabs: [
                  Tab(child: Text("Sorteio")),
                  Tab(child: Text("Resultado")),
                ],
              ),
              title: Text(widget._concurso.name),
              actions: <Widget>[
                PopUpMenu(),
              ]),
          body: TabBarView(
            children: [
              tabSorteio,
              tabResultado,
            ],
          ),
        ),
      ),
    );
  }
}
