/*
* From JSON
{
  "concursosBean": [
     {
      "name": "MEGA-SENA",
      "colorBean": {
        "r": 32,
        "g": 152,
        "b": 105
      },
      "enabled": true,
      "spaceStart":1,
      "spaceEnd": 60,
      "minSize": 6,
      "maxSize": 15
    }
  ]
}
* */

import 'dart:convert';

import 'package:flutter/material.dart';

class Concursos extends Iterable<dynamic> {
  List<ConcursoBean> concursosBeanList = [];

  Concursos({required this.concursosBeanList});

  Concursos.fromJson(Map<String, dynamic> json) {
    this.concursosBeanList = (json['concursosBean'] as List)
        .map((i) => ConcursoBean.fromJson(i))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concursosBean'] =
        this.concursosBeanList.map((i) => i.toJson()).toList();
    return data;
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  static Map<String, dynamic> toMap(String jsonString) {
    return json.decode(jsonString);
  }

  @override
  Iterator get iterator => concursosBeanList.iterator;
}

class ConcursoBean {
  String name;
  bool enabled;
  int spaceStart;
  int spaceEnd;
  int minSize;
  int maxSize;
  ColorBean colorBean;

  ConcursoBean(
      {required this.name,
      required this.enabled,
      required this.spaceStart,
      required this.spaceEnd,
      required this.minSize,
      required this.maxSize,
      required this.colorBean});

  static ConcursoBean fromJson(Map<String, dynamic> json) {
    return ConcursoBean(
        name: json['name'],
        enabled: json['enabled'],
        spaceStart: json['spaceStart'],
        spaceEnd: json['spaceEnd'],
        minSize: json['minSize'],
        maxSize: json['maxSize'],
        colorBean: json['colorBean'] != null
            ? ColorBean.fromJson(json['colorBean'])
            : ColorBean(b: 0, g: 0, r: 0));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    data['spaceStart'] = this.spaceStart;
    data['spaceEnd'] = this.spaceEnd;
    data['minSize'] = this.minSize;
    data['maxSize'] = this.maxSize;
    data['colorBean'] = this.colorBean.toJson();
    return data;
  }

  @override
  String toString() {
    return 'ConcursoBean{name: $name, enabled: $enabled, colorBean: $colorBean}';
  }
}

class ColorBean {
  int r;
  int g;
  int b;

  ColorBean({required this.r, required this.g, required this.b});

  static ColorBean fromJson(Map<String, dynamic> json) {
    return ColorBean(
      r: json['r'] != null ? json['r'] : 0,
      g: json['g'] != null ? json['g'] : 0,
      b: json['b'] != null ? json['b'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r'] = this.r;
    data['g'] = this.g;
    data['b'] = this.b;
    return data;
  }

  Color getColor(BuildContext context) {
    var alpha = Theme.of(context).brightness == Brightness.light ? 255 : 100;
    return Color.fromARGB(alpha, this.r, this.g, this.b);
  }

  @override
  String toString() {
    return 'ColorBean{r: $r, g: $g, b: $b}';
  }
}
