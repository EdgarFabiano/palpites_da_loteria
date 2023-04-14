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
  int colorDark;
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
      required this.colorDark,
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
        colorDark: json['colorDark'],
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
    data['colorDark'] = this.colorDark;
    data['sortOrder'] = this.sortOrder;
    return data;
  }

  @override
  String toString() {
    return 'Contest{id: $id, name: $name, enabled: $enabled, sortOrder: $sortOrder}';
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
    var colorValue = Theme.of(context).brightness == Brightness.light ? this.color : this.colorDark;
    return Color(colorValue).withAlpha(255);
  }
  
  @override
  bool operator == (Object other) =>
      other is Contest &&
          other.runtimeType == this.runtimeType &&
          other.id == this.id;

  @override
  int get hashCode => this.id;
  
}
