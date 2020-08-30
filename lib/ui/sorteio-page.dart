
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/domain/resultado.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/service/generator/random-sorteio-generator.dart';
import 'package:palpites_da_loteria/service/loteria-api-service.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';
import 'package:palpites_da_loteria/widgets/popup-menu.dart';

class SorteioPage extends StatefulWidget {
  final ConcursoBean _concurso;

  SorteioPage(this._concurso, {Key key}) : super(key: key);

  @override
  _SorteioPageState createState() => _SorteioPageState();
}

class _SorteioPageState extends State<SorteioPage> {
  List<Dezena> _dezenas = List();
  AbstractSorteioGenerator _sorteioGenerator = new RandomSorteioGenerator();
  bool _firstTime = true;
  double _sorteioValue;
  int _chance = 3;

  Future<Resultado> futureResultado;

  @override
  void initState() {
    super.initState();
    _sorteioValue = widget._concurso.minSize.toDouble();
    AdMobService.buildInterstitial();
    futureResultado = fetchResultado();
  }

  Future<Resultado> fetchResultado() async {
    var url = LoteriaAPIService.getEndpointFor(widget._concurso.name);
    print(url);
    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      return Resultado.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao buscar resultado');
    }
  }

  void _sortear(double increment) {
    _sorteioValue += increment;
    _dezenas = _sorteioGenerator
        .sortear(_sorteioValue.toInt(), widget._concurso, context)
        .toList();
  }

  void _sortearComAnuncio(double increment) {
    setState(() {
      _sortear(increment);
      _chance++;
      if (_chance >= 5) {
        AdMobService.buildInterstitial()
          ..load()
          ..show();
        _chance = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var refreshButton = RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        label: Text(
          "Gerar novamente",
          style: TextStyle(color: Colors.white),
        ),
        color: widget._concurso.colorBean.getColor(context),
        onPressed: () => _sortearComAnuncio(0));

    if (_firstTime) {
      _sortear(0);
      _firstTime = false;
    }
    var dezenas = GridView(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 60,
      ),
      children: _dezenas.toList(),
    );

    var minSize = widget._concurso.minSize.toDouble();
    var maxSize = widget._concurso.maxSize.toDouble();

    var tabSorteio = Flex(
                children: <Widget>[
                  Visibility(
                    visible: maxSize != minSize,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: _sorteioValue > widget._concurso.minSize,
                            child: FlatButton.icon(
                                onPressed: () => setState(() {
                                      _sortear(-1);
                                    }),
                                icon: Icon(Icons.exposure_neg_1),
                                label: Text("")),
                          ),
                          Text(
                            _sorteioValue.toInt().toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: _sorteioValue < widget._concurso.maxSize,
                            child: FlatButton.icon(
                                onPressed: () => setState(() {
                                      _sortear(1);
                                    }),
                                icon: Icon(Icons.exposure_plus_1),
                                label: Text("")),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(visible: maxSize != minSize, child: Divider()),
                  Flexible(
                    child: dezenas,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: refreshButton,
                  ),
                ],
                direction: Axis.vertical,
              );

    var tabResultado = FutureBuilder<Resultado>(
      future: futureResultado,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.dezenas.toString());
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Loading(size: 10.0, indicator: BallSpinFadeLoaderIndicator(), color: Colors.grey,);
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
