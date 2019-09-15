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

class Concursos {
  List<ConcursoBean> concursosBean;

  Concursos({this.concursosBean});

  Concursos.fromJson(Map<String, dynamic> json) {    
    this.concursosBean = (json['concursosBean'] as List)!=null?(json['concursosBean'] as List).map((i) => ConcursoBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concursosBean'] = this.concursosBean != null?this.concursosBean.map((i) => i.toJson()).toList():null;
    return data;
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  static Map<String, dynamic> toMap(String jsonString) {
    return json.decode(jsonString);
  }

}

class ConcursoBean {
  String name;
  bool enabled;
  int spaceStart;
  int spaceEnd;
  int minSize;
  int maxSize;
  ColorBean colorBean;

  ConcursoBean({this.name, this.enabled, this.spaceStart, this.spaceEnd, this.minSize, this.maxSize, this.colorBean});

  ConcursoBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.enabled = json['enabled'];
    this.spaceStart = json['spaceStart'];
    this.spaceEnd = json['spaceEnd'];
    this.minSize = json['minSize'];
    this.maxSize = json['maxSize'];
    this.colorBean = json['colorBean'] != null ? ColorBean.fromJson(json['colorBean']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    data['spaceStart'] = this.spaceStart;
    data['spaceEnd'] = this.spaceEnd;
    data['minSize'] = this.minSize;
    data['maxSize'] = this.maxSize;
    if (this.colorBean != null) {
      data['colorBean'] = this.colorBean.toJson();
    }
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

  ColorBean({this.r, this.g, this.b});

  ColorBean.fromJson(Map<String, dynamic> json) {
    this.r = json['r'];
    this.g = json['g'];
    this.b = json['b'];
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
