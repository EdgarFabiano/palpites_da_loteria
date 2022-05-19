import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

import '../model/concursos.dart';
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

  Future<ResultadoAPI> fetchResultado(ConcursoBean concursoBean, int concurso) async {
    var url = server + "/api/${concursoBean.getEnpoint()}/$concurso";
    if (concurso != 0) {
      Response response = await _dio.get(url, options: _cacheOptions);
      if (response.statusCode == 200 && response.data is Map) {
        return compute(parseResultado, response.data as Map<String, dynamic>);
      }
    }
    return Future.value(ResultadoAPI());
  }

  Future<ResultadoAPI> fetchLatestResultado(ConcursoBean concursoBean) async {
    var url = server + "/api/${concursoBean.getEnpoint()}/latest";
    Response response = await _dio.get(url, options: _cacheOptions);

    if (response.statusCode == 200 && response.data is Map) {
      return compute(parseResultado, response.data as Map<String, dynamic>);
    }
    return Future.value(ResultadoAPI());
  }

}
