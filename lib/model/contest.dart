/*
* From JSON
{
  "concursosBean": [
     {
      "name": "MEGA-SENA",
      "colorBean": "Ox112233",
      "enabled": true,
      "spaceStart":1,
      "spaceEnd": 60,
      "minSize": 6,
      "maxSize": 15
    }
  ]
}
* */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Contest {
  int id;
  String name;
  bool enabled;
  int spaceStart;
  int spaceEnd;
  int minSize;
  int maxSize;
  int color;
  int sortOrder;

  Contest(
      {required this.id,
        required this.name,
        required this.enabled,
        required this.spaceStart,
        required this.spaceEnd,
        required this.minSize,
        required this.maxSize,
        required this.color,
        required this.sortOrder});

  static Contest fromJson(Map<String, dynamic> json) {
    return Contest(
        id: json['id'],
        name: json['name'],
        enabled: json['enabled'] == 1,
        spaceStart: json['spaceStart'],
        spaceEnd: json['spaceEnd'],
        minSize: json['minSize'],
        maxSize: json['maxSize'],
        color: json['color'],
        sortOrder: json['sortOrder']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['enabled'] = this.enabled ? 1 : 0;
    data['spaceStart'] = this.spaceStart;
    data['spaceEnd'] = this.spaceEnd;
    data['minSize'] = this.minSize;
    data['maxSize'] = this.maxSize;
    data['color'] = this.color;
    data['sortOrder'] = this.sortOrder;
    return data;
  }

  @override
  String toString() {
    return 'Contest{id: $id, name: $name, enabled: $enabled, color: $color}';
  }

  String getEnpoint() {
    switch (this.name) {
      case 'MEGA-SENA':
      case 'MG. SENA':
        return 'mega-sena';

      case 'LOTOFÁCIL':
      case 'LT. FÁCIL':
        return 'lotofacil';

      case 'QUINA':
      case 'QN':
        return 'quina';

      case 'LOTOMANIA':
      case 'LT. MANIA':
        return 'lotomania';

      case 'TIMEMANIA':
      case 'TM. MANIA':
        return 'timemania';

      case 'DUPLA SENA':
      case 'D. SENA':
        return 'dupla-sena';

      case 'DIA DE SORTE':
      case 'D. DE SORTE':
        return 'dia-de-sorte';

      default:
        return '';
    }
  }

  Color getColor(BuildContext context) {
    var alpha = Theme.of(context).brightness == Brightness.light ? 0xFF : 0x64;
    return Color(this.color).withAlpha(alpha);
  }
}

