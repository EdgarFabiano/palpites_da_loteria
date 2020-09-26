
import 'package:flutter/material.dart';

class InternetNotAvailable extends StatelessWidget {
  const InternetNotAvailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      color: themeData.brightness == Brightness.light ? Colors.grey : themeData.cardColor,
      padding: EdgeInsets.all(16.0),
      child: Text('Verifique sua conexão com a internet',
          style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}