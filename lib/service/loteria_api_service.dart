import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
Options _cacheOptions =
    buildCacheOptions(Duration(minutes: 5), forceRefresh: true);
Dio _dio = Dio();

ResultadoAPI parseResultado(Map<String, dynamic> responseBody) {
  return ResultadoAPI.fromJson(responseBody);
}

class LoteriaAPIService {
  final String _server =
      'https://edgar.outsystemscloud.com/LoteriaService/rest/Resultado';
  final String _username = 'loteria_service';
  final String _password = 'E862415l!';
  String? _basicAuth;

  static final LoteriaAPIService _singleton = LoteriaAPIService._internal();

  factory LoteriaAPIService() {
    return _singleton;
  }

  LoteriaAPIService._internal() {
    _dio.interceptors.add(_dioCacheManager.interceptor);
    _basicAuth = 'Basic ' + base64.encode(utf8.encode('$_username:$_password'));
    _cacheOptions.headers = {'Authorization': _basicAuth!};
  }

  Future<ResultadoAPI> fetchResultado(
      Contest contest, int concurso) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/$concurso";

    if (concurso != 0) {
      Response response = await _dio.get(url, options: _cacheOptions);
      if (response.statusCode == 200 && response.data is Map) {
        return compute(parseResultado, response.data as Map<String, dynamic>);
      }
    }
    return Future.value(ResultadoAPI());
  }

  Future<ResultadoAPI> fetchLatestResultado(Contest contest) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/Latest";
    Response response = await _dio.get(url, options: _cacheOptions);

    if (response.statusCode == 200 && response.data is Map) {
      return compute(parseResultado, response.data as Map<String, dynamic>);
    }
    return Future.value(ResultadoAPI());
  }
}
