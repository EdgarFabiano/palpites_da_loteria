import 'package:flutter/material.dart';

import '../service/format_service.dart';

class GuessNumberWidget extends StatefulWidget {
  final String _guessNumber;
  final Color _color;
  final int? _frequency;
  final bool _showFrequency;

  GuessNumberWidget(this._guessNumber, this._color,
      [this._showFrequency = false, this._frequency, Key? key])
      : super(key: key);

  @override
  _GuessNumberWidgetState createState() => _GuessNumberWidgetState();
}

class _GuessNumberWidgetState extends State<GuessNumberWidget> {
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
                formatGuessNumber(widget._guessNumber),
                style: TextStyle(
                  fontSize: widget._showFrequency ? null : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget._showFrequency && widget._frequency != null,
            child: Divider(height: 0),
          ),
          Flexible(
            child: Visibility(
                visible: widget._showFrequency && widget._frequency != null,
                child: Text(
                  widget._frequency.toString(),
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
