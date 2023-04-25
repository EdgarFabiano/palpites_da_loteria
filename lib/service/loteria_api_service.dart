import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../defaults/constants.dart';
import 'format_service.dart';

LotteryAPIResult parseResultado(Map<String, dynamic> responseBody) {
  return LotteryAPIResult.fromJson(responseBody);
}

class LoteriaAPIService {
  final String _server =
      'https://edgar.outsystemscloud.com/LoteriaService/rest/Resultado';
  final String _username = 'loteria_service';
  final String _password = 'E862415l!';
  late final String _basicAuth;

  final _cacheOptions =
  CacheOptions(store: MemCacheStore(), maxStale: Duration(minutes: 5));
  final Dio _dio = Dio();
  late final Options _options;

  static final LoteriaAPIService _singleton = LoteriaAPIService._internal();

  factory LoteriaAPIService() {
    return _singleton;
  }

  LoteriaAPIService._internal() {
    _basicAuth = 'Basic ' + base64.encode(utf8.encode('$_username:$_password'));
    _cacheOptions.toOptions().headers = {'Authorization': _basicAuth};
    _options = _cacheOptions.toOptions();
    _options.headers = {'Authorization': _basicAuth};
  }

  Future<LotteryAPIResult> fetchResultado(Contest contest, int concurso) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/$concurso";
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_contestResult,
      parameters: {
        Constants.pm_ContestName: contest.name,
        Constants.pm_ContestNumber: concurso.toString(),
        Constants.pm_date: formatarDataHora(DateTime.now()),
      },
    );

    if (concurso != 0) {
      Response response =
          await _dio.get(url, options: _options);
      if (response.statusCode == 200 && response.data is Map) {
        return compute(parseResultado, response.data as Map<String, dynamic>);
      }
    }
    return Future.value(LotteryAPIResult());
  }

  Future<LotteryAPIResult> fetchLatestResultado(Contest contest) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/Latest";
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_contestResult,
      parameters: {
        Constants.pm_ContestName: contest.name,
        Constants.pm_ContestNumber: 'latest',
        Constants.pm_date: formatarDataHora(DateTime.now()),
      },
    );

    Response response = await _dio.get(url, options: _options);

    if (response.statusCode == 200 && response.data is Map) {
      return compute(parseResultado, response.data as Map<String, dynamic>);
    }
    return Future.value(LotteryAPIResult());
  }
}
