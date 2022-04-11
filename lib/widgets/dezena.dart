import 'package:flutter/material.dart';

class Dezena extends StatefulWidget {
  final String _dezena;
  final Color _color;
  bool tapped = false;

  Dezena(this._dezena, this._color, [this.tapped = false, Key? key]) : super(key: key);

  @override
  _DezenaState createState() => _DezenaState();
}

class _DezenaState extends State<Dezena> {


  Widget _getDezenaDisplayWidget() {
    String text = widget._dezena.toString();
    if (widget.tapped) {
      text = "X";
    } else if (int.parse(widget._dezena) < 10) {
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
      onTap: () => setState(() => widget.tapped = !widget.tapped),
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
