import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConcursoService {
  static Future<Concursos> getBaselineFuture(BuildContext context) async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString(Constants.concursosBaselineJson);
    Map<String, dynamic> map = Concursos.toMap(jsonString);
    return Concursos.fromJson(map);
  }

  static Future<Concursos> getUsersConcursosFuture(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String usersConcursos =
    await prefs.get(Constants.concursosSharedPreferencesKey);

    if (usersConcursos == null) {
      await getBaselineFuture(context).then((onValue) => prefs.setString(
          Constants.concursosSharedPreferencesKey,
          json.encode(onValue.toJson())));
    }

    Map<String, dynamic> map = Concursos.toMap(usersConcursos);

    return Concursos.fromJson(map);
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
    concursos.concursosBean.forEach((element) {
      if (element.name == concurso.name) {
        element.enabled = concurso.enabled;
      }
    });
    prefs.setString(
        Constants.concursosSharedPreferencesKey, concursos.toJsonString());
  }
}
