import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/defaults/Constants.dart';

class CardConcursos extends StatefulWidget {
  const CardConcursos(this._concurso, {Key key}) : super(key: key);
  final ConcursoBean _concurso;

  @override
  _CardConcursosState createState() => _CardConcursosState();
}

class _CardConcursosState extends State<CardConcursos> {
  Widget build(BuildContext context) {
    var cardColor = widget._concurso.colorBean.getColor();
    return Card(
          color: cardColor ,
          child: SizedBox(
            width:  162,
            height: 162,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Constants.loteriasIconAssetPath,
                  height: 80,
                  width: 80,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    widget._concurso.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ));
  }
}
