import 'package:flutter/material.dart';

import '../service/format_service.dart';

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
              child: Text(
                formatGuessNumber(widget._dezena),
                style: TextStyle(
                  fontSize: widget._showFrequencia ? null : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                    color: Colors.white54,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
