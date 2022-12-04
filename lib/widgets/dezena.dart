import 'package:flutter/material.dart';

class Dezena extends StatefulWidget {
  final String _dezena;
  final Color _color;
  final int? _frequencia;
  bool _showFrequencia;

  Dezena(this._dezena, this._color,
      [this._showFrequencia = false, this._frequencia, Key? key])
      : super(key: key);

  @override
  _DezenaState createState() => _DezenaState();
}

class _DezenaState extends State<Dezena> {
  Widget _getDezenaDisplayWidget() {
    String text = widget._dezena.toString();
    if (int.parse(widget._dezena) < 10) {
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
    return Card(
      elevation: 2,
      color: widget._color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
              child: _getDezenaDisplayWidget(),
            ),
          ),
          Visibility(
            visible: widget._showFrequencia && widget._frequencia != null,
            child: Divider(height: 0),
          ),
          Flexible(
            child: Visibility(
                visible: widget._showFrequencia && widget._frequencia != null,
                child: Text(
                  widget._frequencia.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
