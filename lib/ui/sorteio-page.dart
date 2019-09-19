import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/ad-units.dart';
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
  double _sliderValue;
  int _chance = 0;

  void _sortear() {
    _dezenas = _sorteioGenerator
        .sortear(_sliderValue.toInt(), widget._concurso, context)
        .toList();
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
    _sliderValue = widget._concurso.minSize.toDouble();
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

    var slider = Center();

    if (maxSize != minSize) {
      slider = Center(
        child: Slider.adaptive(
          activeColor: widget._concurso.colorBean.getColor(context),
          divisions: (maxSize - minSize).toInt(),
          min: minSize,
          max: maxSize,
          value: _sliderValue,
          onChangeEnd: (value) {
            setState(() {
              _sortear();
            });
          },
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
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
            slider,
            Flexible(
              child: dezenas,
            ),
          ],
          direction: Axis.vertical,
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AdUnits.bannerPadding),
        child: FloatingActionButton(
          tooltip: "Gerar novamente",
          backgroundColor: widget._concurso.colorBean.getColor(context),
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _sortear();
              _chance++;
              if (_chance == 2) {
                _sorteioInterstitial.show();
                _loadInterstitial();
                _chance = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
