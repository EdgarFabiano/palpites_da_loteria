
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardConcursos extends StatefulWidget {

  CardConcursos(this._cardColor, {Key key}) : super(key: key);
  Color _cardColor = Colors.black;

  @override
  _CardConcursosState createState() => _CardConcursosState();
}

class _CardConcursosState extends State<CardConcursos> {
  double _leftRightPadding = 50;
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          color: widget._cardColor,
          child: Padding(
            padding: EdgeInsets.only(left: _leftRightPadding, right: _leftRightPadding, top: 20),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/loterias.png",
                  height: 80,
                  width: 80,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "MEGA-SENA",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
