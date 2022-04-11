import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

import '../model/resultado_api.dart';

DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
Options _cacheOptions =
buildCacheOptions(Duration(minutes: 5), forceRefresh: true);
Dio _dio = Dio();

ResultadoAPI parseResultado(Map<String, dynamic> responseBody) {
  return ResultadoAPI.fromJson(responseBody);
}

class LoteriaAPIService {

  static final LoteriaAPIService _singleton = LoteriaAPIService._internal();

  factory LoteriaAPIService() {
    _dio.interceptors.add(_dioCacheManager.interceptor);
    return _singleton;
  }

  LoteriaAPIService._internal();

  static String server = "https://loteriascaixa-api.herokuapp.com";

  Future<ResultadoAPI> fetchResultado(String concursoName, int concurso) async {
    var url = _getEndpointFor(concursoName, concurso);
    if (concurso != 0) {
      Response response = await _dio.get(url, options: _cacheOptions);
      if (response.statusCode == 200 && response.data is Map) {
        return compute(parseResultado, response.data as Map<String, dynamic>);
      }
    }
    return Future.value(ResultadoAPI());
  }

  Future<ResultadoAPI> fetchLatestResultado(String concursoName) async {
    var url = _getLatestEndpointFor(concursoName);
    Response response = await _dio.get(url, options: _cacheOptions);

    if (response.statusCode == 200 && response.data is Map) {
      return compute(parseResultado, response.data as Map<String, dynamic>);
    }
    return Future.value(ResultadoAPI());
  }

  // Returns the url path for the concurso name
  String _getEndpointFor(String concursoName, int consursoNumber) {
    return server +
        "/api/${_getConcursoEnpointNameFor(concursoName)}/$consursoNumber";
  }

  String _getLatestEndpointFor(String concursoName) {
    return server +
        "/api/${_getConcursoEnpointNameFor(concursoName)}/latest";
  }

  // Returns the name to be used on the API loterias based on the concurso's
  // name provided on the Json file "baseline.json".
  String _getConcursoEnpointNameFor(String concursoName) {
    switch (concursoName) {
      case "MEGA-SENA":
      case "MG. SENA":
        return "mega-sena";

      case "LOTOFÁCIL":
      case "LT. FÁCIL":
        return "lotofacil";

      case "QUINA":
      case "QN":
        return "quina";

      case "LOTOMANIA":
      case "LT. MANIA":
        return "lotomania";

      case "TIMEMANIA":
      case "TM. MANIA":
        return "timemania";

      case "DUPLA SENA":
      case "D. SENA":
        return "dupla-sena";

      case "DIA DE SORTE":
      case "D. DE SORTE":
        return "dia-de-sorte";

      default:
        return "";
    }
  }

}
