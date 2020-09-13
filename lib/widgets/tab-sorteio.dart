
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/admob-service.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/service/generator/random-sorteio-generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class TabSorteio extends StatefulWidget {

  final ConcursoBean _concurso;

  TabSorteio(this._concurso);

  @override
  _TabSorteioState createState() => _TabSorteioState();
}

class _TabSorteioState extends State<TabSorteio> {

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
        AdMobService.buildInterstitial()
          ..load()
          ..show();
        _chance = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sorteioValue = widget._concurso.minSize.toDouble();
    AdMobService.buildInterstitial();
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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: widget._concurso.colorBean.getColor(context),
        onPressed: () => _sortearComAnuncio(0));

    if (_firstTime) {
      _sortear(0);
      _firstTime = false;
    }

    var minSize = widget._concurso.minSize.toDouble();
    var maxSize = widget._concurso.maxSize.toDouble();
    var width = MediaQuery.of(context).size.width;

    return Flex(
      direction: Axis.vertical,
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
          child: GridView.extent(
            maxCrossAxisExtent: width/8 + 20,
            shrinkWrap: false,
            padding: EdgeInsets.all(10),
            children: _dezenas.toList(),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: refreshButton,
        ),
      ],
    );
  }
}
