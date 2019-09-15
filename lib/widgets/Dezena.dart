import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dezena extends StatefulWidget {
  final int _dezena;
  final Color _color;

  const Dezena(this._dezena, this._color, {Key key}) : super(key: key);

  @override
  _DezenaState createState() => _DezenaState();
}

class _DezenaState extends State<Dezena> {

  bool tapped = false;

  Widget _getDezenaDisplayWidget() {
    String text = widget._dezena.toString();
    if (tapped) {
      text = "X";
    } else if (widget._dezena < 10) {
      text = "0" + widget._dezena.toString();
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  void _switch() {
    setState(() {
      tapped = !tapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 50.0;
    Widget circle = GestureDetector(
      onTap: () => _switch(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget._color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _getDezenaDisplayWidget(),
        ),
      ),
    );

    return circle;
  }
}
