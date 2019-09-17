import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/AdUnits.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/service/generator/AbstractSorteioGenerator.dart';
import 'package:palpites_da_loteria/service/generator/RandomSorteioGenerator.dart';
import 'package:palpites_da_loteria/widgets/Dezena.dart';
import 'package:palpites_da_loteria/widgets/PopUpMenu.dart';

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
  InterstitialAd _sorteioInterstitial;

  void _sortear() {
    var concurso = widget._concurso;
    _dezenas =
        _sorteioGenerator.sortear(concurso.minSize, concurso, context).toList();
  }

  @override
  void initState() {
    _sorteioInterstitial = InterstitialAd(
      adUnitId: AdUnits.getSorteioInterstitialId(),
      targetingInfo: MobileAdTargetingInfo(testDevices: ["30B81A47E3005ADC205D4BCECC4450E1"]),
    );
    _sorteioInterstitial.load();
  }

  @override
  Widget build(BuildContext context) {
    _sortear();
    var dezenas = GridView(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 60,
      ),
      children: _dezenas.toList(),
    );

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
      body: dezenas,
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget._concurso.colorBean.getColor(context),
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _sortear();
            _sorteioInterstitial.show();
            initState();
          });
        },
      ),
    );
  }
}
