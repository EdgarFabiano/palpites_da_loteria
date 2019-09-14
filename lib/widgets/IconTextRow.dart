

import 'package:flutter/cupertino.dart';

class IconTextRow extends StatelessWidget {
  final IconData _icon;
  final String _text;

  IconTextRow(this._icon, this._text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          _icon,
          size: 20,
        ),
        Container(
          padding: EdgeInsets.only(right: 10),
        ),
        Text(
          _text,
        ),
      ],
    );
  }

}