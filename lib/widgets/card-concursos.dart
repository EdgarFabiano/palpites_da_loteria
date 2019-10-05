import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/ui/sorteio-page.dart';

class CardConcursos extends StatefulWidget {
  const CardConcursos(this._concursoBean, {Key key}) : super(key: key);
  final ConcursoBean _concursoBean;

  ConcursoBean get concursoBean => _concursoBean;

  @override
  _CardConcursosState createState() => _CardConcursosState();
}

class _CardConcursosState extends State<CardConcursos> {
  Widget build(BuildContext context) {
    var cardColor = widget._concursoBean.colorBean.getColor(context);
    var loteriasIconAssetPath = Constants.loteriasIconAssetPath;
    var name = widget._concursoBean.name;
    return GestureDetector(onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SorteioPage(widget._concursoBean),
        ),
      );
    }, child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var maxWidth = constraints.maxWidth;
      var maxHeight = constraints.maxHeight;

      return Card(
        color: cardColor,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                loteriasIconAssetPath,
                height: maxWidth / 2,
                width: maxWidth / 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: maxHeight/10),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: maxHeight / 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
