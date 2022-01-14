
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/admob_service.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/service/generator/random_sorteio_generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class TabSorteio extends StatefulWidget {
  final ConcursoBean concursoBean;
  const TabSorteio(this.concursoBean, {Key key}) : super(key: key);

  @override
  _TabSorteioState createState() => _TabSorteioState();
}

class _TabSorteioState extends State<TabSorteio> with AutomaticKeepAliveClientMixin {

  List<Dezena> _dezenas = [];
  AbstractSorteioGenerator _sorteioGenerator = new RandomSorteioGenerator();
  bool _primeiraVez = true;
  double _numeroDeDezenasASortear;
  int _chance = 3;

  void _sortear(double increment) {
    _numeroDeDezenasASortear += increment;
    _dezenas = _sorteioGenerator
        .sortear(_numeroDeDezenasASortear.toInt(), widget.concursoBean, context)
        .toList();
  }

  void _sortearComAnuncio(double increment) {
    setState(() {
      _sortear(increment);
      _chance++;
      if (_chance >= 5) {
        AdMobService.buildSorteioInterstitial()
          ..load()
          ..show();
        _chance = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _numeroDeDezenasASortear = widget.concursoBean.minSize.toDouble();
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
        color: widget.concursoBean.colorBean.getColor(context),
        onPressed: () => _sortearComAnuncio(0));

    if (_primeiraVez) {
      _sortearComAnuncio(0);
      _primeiraVez = false;
    }

    var minSize = widget.concursoBean.minSize.toDouble();
    var maxSize = widget.concursoBean.maxSize.toDouble();
    var width = MediaQuery.of(context).size.width;

    return Column(
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
                  visible: _numeroDeDezenasASortear > widget.concursoBean.minSize,
                  child: FlatButton.icon(
                      onPressed: () => setState(() {
                        _sortear(-1);
                      }),
                      icon: Icon(Icons.exposure_neg_1),
                      label: Text("")),
                ),
                Text(
                  _numeroDeDezenasASortear.toInt().toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _numeroDeDezenasASortear < widget.concursoBean.maxSize,
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
        Visibility(visible: maxSize != minSize, child: Divider(height: 0,)),
        Expanded(
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

  @override
  bool get wantKeepAlive => true;
}
