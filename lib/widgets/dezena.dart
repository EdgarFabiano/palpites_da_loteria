import 'package:flutter/material.dart';

class Dezena extends StatefulWidget {
  final String _dezena;
  final Color _color;
  final bool _show0;

  const Dezena(this._dezena, this._color, this._show0, {Key key}) : super(key: key);

  @override
  _DezenaState createState() => _DezenaState();
}

class _DezenaState extends State<Dezena> {
  bool tapped = false;

  Widget _getDezenaDisplayWidget() {
    String text = widget._dezena.toString();
    if (tapped) {
      text = "X";
    } else if (int.parse(widget._dezena) < 10 && widget._show0) {
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

  @override
  Widget build(BuildContext context) {
    Widget circle = GestureDetector(
      onTap: () => setState(() => tapped = !tapped),
      child: Card(
        elevation: 2,
        color: widget._color,
        shape: CircleBorder(),
        child: Center(
          child: _getDezenaDisplayWidget(),
        ),
      ),
    );

    return circle;
  }
}
