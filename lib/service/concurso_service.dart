import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _updated = false;

Concursos parseJson(String jsonString) {
  Map<String, dynamic> map = Concursos.toMap(jsonString);
  return Concursos.fromJson(map);
}

Future<Concursos> getBaselineFuture() async {
  String jsonString =
      await rootBundle.loadString(Constants.concursosBaselineJson);
  return compute(parseJson, jsonString);
}

Future<Concursos> getUsersConcursosFuture() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringConcursos =
      await prefs.get(Constants.concursosSharedPreferencesKey);

  if (stringConcursos == null) {
    await getBaselineFuture().then((onValue) => prefs.setString(
        Constants.concursosSharedPreferencesKey,
        json.encode(onValue.toJson())));
    stringConcursos = await prefs.get(Constants.concursosSharedPreferencesKey);
    _updated = true;
  }

  Concursos concursos = await compute(parseJson, stringConcursos);

  if (!_updated) {
    _updateBaselineChanges(concursos, prefs);
    _updated = true;
  }

  return concursos;
}

/*This method is used to update user concursos list attributes due to permanent changes in baseline.json for older installations only*/
void _updateBaselineChanges(Concursos concursos, SharedPreferences prefs) {
  /*This is needed because the last version baseline.json contained 18 as maxSize for "LOTOFÁCIL" contest*/
  var lotofacil = concursos.concursosBeanList
      .where((element) => element.name == "LOTOFÁCIL");

  if (lotofacil != null && lotofacil.isNotEmpty) lotofacil.first.maxSize = 20;

  /*Updates the name due to copyrights infringement*/
  concursos.concursosBeanList
      .forEach((element) => element.name = getNewName(element.name));

  prefs.setString(
      Constants.concursosSharedPreferencesKey, concursos.toJsonString());
}

String getNewName(String concursoName) {
  switch (concursoName) {
    case "MEGA-SENA":
      return "MG. SENA";

    case "LOTOFÁCIL":
      return "LT. FÁCIL";

    case "QUINA":
      return "QN";

    case "LOTOMANIA":
      return "LT. MANIA";

    case "TIMEMANIA":
      return "TM. MANIA";

    case "DUPLA SENA":
      return "D. SENA";

    case "DIA DE SORTE":
      return "D. DE SORTE";

    default:
      return concursoName;
  }
}

void saveConcursos(Concursos concursos) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
      Constants.concursosSharedPreferencesKey, concursos.toJsonString());
}

void saveConcurso(ConcursoBean concurso) async {
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
