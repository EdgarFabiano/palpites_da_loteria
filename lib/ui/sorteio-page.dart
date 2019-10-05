import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/service/generator/random-sorteio-generator.dart';
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
  bool _favorited = false;
  bool _firstTime = true;
  InterstitialAd _sorteioInterstitial;
  double _sorteioValue;
  int _chance = 0;

  void _sortear() {
    _dezenas = _sorteioGenerator
        .sortear(_sorteioValue.toInt(), widget._concurso, context)
        .toList();
  }

  void _sortearComAnuncio(double increment) {
    _sorteioValue += increment;
    setState(() {
      _sortear();
      _chance++;
      if (_chance == 2 && !Constants.isDevMode) {
        _sorteioInterstitial.show();
        _loadInterstitial();
        _chance = 0;
      }
    });
  }

  void _loadInterstitial() {
    _sorteioInterstitial = InterstitialAd(
      adUnitId: AdUnits.getSorteioInterstitialId(),
      targetingInfo: MobileAdTargetingInfo(
//          testDevices: ["30B81A47E3005ADC205D4BCECC4450E1"]
          ),
    );
    _sorteioInterstitial.load();
  }

  @override
  void initState() {
    _sorteioValue = widget._concurso.minSize.toDouble();
    _loadInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      _sortear();
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

    var refreshButton = SizedBox(
      width: double.infinity,
      child: RaisedButton.icon(
          icon: Icon(Icons.refresh),
          label: Text("Gerar novamente"),
          color: widget._concurso.colorBean.getColor(context),
          onPressed: () => _sortearComAnuncio(0)),
    );

    Widget controlsButton = Center();

    if (maxSize != minSize) {
      controlsButton = Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton.icon(
                onPressed: () => (_sorteioValue > widget._concurso.minSize ? _sortearComAnuncio(-1) : null),
                icon: Icon(Icons.exposure_neg_1),
                label: Text("")),
            Text(_sorteioValue.toInt().toString()),
            FlatButton.icon(
                onPressed: () => (_sorteioValue < widget._concurso.maxSize ? _sortearComAnuncio(1) : null),
                icon: Icon(Icons.exposure_plus_1),
                label: Text("")),
          ],
        ),
        padding: EdgeInsets.only(top: 5),
      );
    }

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
            tooltip: "Salvar jogo",
            icon: Icon(!_favorited ? Icons.favorite_border : Icons.favorite),
            onPressed: () {
              setState(() {
                _favorited = !_favorited;
              });
            },
          ),
          PopUpMenu(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
        child: Flex(
          children: <Widget>[
            controlsButton,
            Flexible(
              child: dezenas,
            ),
            Column(
              children: <Widget>[refreshButton],
            ),
          ],
          direction: Axis.vertical,
        ),
      ),
    );
  }
}
