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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SorteioPage(widget._concursoBean),
          ),
        );
      },
      child: Card(
        color: cardColor,
        child: SizedBox(
          width: 162,
          height: 162,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                loteriasIconAssetPath,
                height: 80,
                width: 80,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
