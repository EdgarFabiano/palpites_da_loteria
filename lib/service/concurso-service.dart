import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart' show rootBundle;

class ConcursoService {
  static String className = "ConcursoService";

  static Future<Concursos> getBaselineFuture() async {
    developer.log("Awaiting '" + Constants.concursosBaselineJson + "'", name: className);
    String jsonString = await rootBundle.loadString(Constants.concursosBaselineJson);
    Map<String, dynamic> map = Concursos.toMap(jsonString);
    return Concursos.fromJson(map);
  }

  static Future<Concursos> getUsersConcursosFuture() async {
    developer.log("Awaiting 'Shared Preferences'", name: className);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    developer.log("Awaiting '" + Constants.concursosSharedPreferencesKey + "'", name: className);
    String usersConcursos =
    await prefs.get(Constants.concursosSharedPreferencesKey);

    if (usersConcursos == null) {
      await getBaselineFuture().then((onValue) => prefs.setString(
          Constants.concursosSharedPreferencesKey,
          json.encode(onValue.toJson())));
    }

    Map<String, dynamic> map = Concursos.toMap(usersConcursos);

    return Concursos.fromJson(map);
  }

  static void saveConcursos(Concursos concursos) async {
    developer.log("Awaiting 'Shared Preferences'", name: className);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        Constants.concursosSharedPreferencesKey, concursos.toJsonString());
  }

  static void saveConcurso(ConcursoBean concurso) async {
    developer.log("Awaiting 'Shared Preferences'", name: className);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    developer.log("Awaiting '" + Constants.concursosSharedPreferencesKey + "'", name: className);
    String usersConcursos =
    await prefs.get(Constants.concursosSharedPreferencesKey);
    Map<String, dynamic> map = Concursos.toMap(usersConcursos);
    Concursos concursos = Concursos.fromJson(map);
    concursos.concursosBeanList.forEach((element) {
      if (element.name == concurso.name) {
        element.enabled = concurso.enabled;
      }
    });
    prefs.setString(
        Constants.concursosSharedPreferencesKey, concursos.toJsonString());
  }
}
