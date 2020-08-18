import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/service/generator/random-sorteio-generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

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
        AdMobService.showSorteioInterstitial();
        AdMobService.getSorteioInterstitial();
        _chance = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sorteioValue = widget._concurso.minSize.toDouble();
    AdMobService.getSorteioInterstitial();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        backgroundColor: widget._concurso.colorBean.getColor(context),
        title: Text(widget._concurso.name),
        actions: <Widget>[
          IconButton(
              tooltip: "Gerar novamente",
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => _sortearComAnuncio(0)),
//          PopUpMenu(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AdMobService.getBannerSize(context)),
        child: Flex(
          children: <Widget>[
            Visibility(
              visible: maxSize != minSize,
              child: Padding(
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
                padding: EdgeInsets.only(top: 5, left: 12, right: 12),
              ),
            ),
            Visibility(visible: maxSize != minSize, child: Divider()),
            Flexible(
              child: dezenas,
            ),
          ],
          direction: Axis.vertical,
        ),
      ),
      bottomSheet: AdMobService.getConcursosBanner(),
    );
  }
}
