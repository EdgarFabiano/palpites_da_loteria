import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConcursoService {
  static bool updated = false;
  static String className = "ConcursoService";

  static Future<Concursos> getBaselineFuture() async {
    String jsonString = await rootBundle.loadString(Constants.concursosBaselineJson);
    Map<String, dynamic> map = Concursos.toMap(jsonString);
    return Concursos.fromJson(map);
  }

  static Future<Concursos> getUsersConcursosFuture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringConcursos =
    await prefs.get(Constants.concursosSharedPreferencesKey);

    if (stringConcursos == null) {
      await getBaselineFuture().then((onValue) => prefs.setString(
          Constants.concursosSharedPreferencesKey,
          json.encode(onValue.toJson())));
      stringConcursos =
      await prefs.get(Constants.concursosSharedPreferencesKey);
      updated = true;
    }

    Map<String, dynamic> map = Concursos.toMap(stringConcursos);
    Concursos concursos = Concursos.fromJson(map);

    if(!updated) {
      _updateBaselineChanges(concursos, prefs);
      updated = true;
    }

    return concursos;
  }

  static void saveConcursos(Concursos concursos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        Constants.concursosSharedPreferencesKey, concursos.toJsonString());
  }

  static void saveConcurso(ConcursoBean concurso) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  /*This method is used to update user concursos list attributes due to permanent changes in baseline.json for older installations only*/
  static void _updateBaselineChanges(Concursos concursos, SharedPreferences prefs) {
    /*This is needed because the last version baseline.json contained 18 as maxSize for "LOTOFÁCIL" contest*/
    concursos.concursosBeanList
        .where((element) => element.name == "LOTOFÁCIL")
        .first.maxSize = 20;

    prefs.setString(Constants.concursosSharedPreferencesKey, concursos.toJsonString());
  }
}
