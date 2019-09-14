

import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  
  final String _message;

  ErrorWidget(this._message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(_message),
        ),
      ),
    );
  }

}