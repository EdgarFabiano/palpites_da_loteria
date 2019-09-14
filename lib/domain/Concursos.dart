/*
* From JSON
{
  "concursosBean": [
     {
    "name": "MEGA-SENA",
    "colorBean": {
      "r": 1,
      "g": 1,
      "b": 1,
      "a": 1
    },
    "position": 1,
    "enabled": true,
    "totalSize": 1,
    "minSize": 1,
    "maxSize": 1
  }
  ]
}
* */

import 'dart:convert';
import 'package:flutter/material.dart';

class Concursos {
  List<ConcursoBean> concursosBean;

  Concursos({this.concursosBean});

  Concursos.fromJson(Map<String, dynamic> jsonMap) {
    this.concursosBean = (jsonMap['concursosBean'] as List) != null
        ? (jsonMap['concursosBean'] as List)
            .map((i) => ConcursoBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['concursosBean'] = this.concursosBean != null
        ? this.concursosBean.map((i) => i.toJson()).toList()
        : null;
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
  int position;
  int totalSize;
  int minSize;
  int maxSize;
  ColorBean colorBean;

  ConcursoBean(
      {this.name,
      this.enabled,
      this.position,
      this.totalSize,
      this.minSize,
      this.maxSize,
      this.colorBean});

  ConcursoBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.enabled = json['enabled'];
    this.position = json['position'];
    this.totalSize = json['totalSize'];
    this.minSize = json['minSize'];
    this.maxSize = json['maxSize'];
    this.colorBean =
        json['colorBean'] != null ? ColorBean.fromJson(json['colorBean']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    data['position'] = this.position;
    data['totalSize'] = this.totalSize;
    data['minSize'] = this.minSize;
    data['maxSize'] = this.maxSize;
    if (this.colorBean != null) {
      data['colorBean'] = this.colorBean.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ConcursoBean{name: $name, enabled: $enabled, position: $position, colorBean: $colorBean}';
  }


}

class ColorBean {
  int r;
  int g;
  int b;
  int a;

  ColorBean({this.r, this.g, this.b, this.a});

  ColorBean.fromJson(Map<String, dynamic> json) {
    this.r = json['r'];
    this.g = json['g'];
    this.b = json['b'];
    this.a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['r'] = this.r;
    data['g'] = this.g;
    data['b'] = this.b;
    data['a'] = this.a;
    return data;
  }

  Color getColor() {
    return Color.fromARGB(this.a, this.r, this.g, this.b);
  }

  @override
  String toString() {
    return 'ColorBean{r: $r, g: $g, b: $b, a: $a}';
  }

}
