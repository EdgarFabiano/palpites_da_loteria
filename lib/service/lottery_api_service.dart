import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../defaults/constants.dart';
import 'format_service.dart';

LotteryAPIResult parseResult(Map<String, dynamic> responseBody) {
  return LotteryAPIResult.fromJson(responseBody);
}

class LotteryAPIService {
  final String _server =
      'https://edgar.outsystemscloud.com/LoteriaService/rest/Resultado';
  final String _username = 'loteria_service';
  final String _password = 'E862415l!';
  late final String _basicAuth;

  final _cacheOptions =
      CacheOptions(store: MemCacheStore(), maxStale: Duration(minutes: 5));
  final Dio _dio = Dio();
  late final Options _options;

  static final LotteryAPIService _singleton = LotteryAPIService._internal();

  factory LotteryAPIService() {
    return _singleton;
  }

  LotteryAPIService._internal() {
    _basicAuth = 'Basic ' + base64.encode(utf8.encode('$_username:$_password'));
    _cacheOptions.toOptions().headers = {'Authorization': _basicAuth};
    _options = _cacheOptions.toOptions();
    _options.headers = {'Authorization': _basicAuth};
  }

  Future<LotteryAPIResult> fetchResult(Contest contest, int contestNumber) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/$contestNumber";
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_contestResult,
      parameters: {
        Constants.pm_ContestName: contest.name,
        Constants.pm_ContestNumber: contestNumber.toString(),
        Constants.pm_date: formatBrDateTime(DateTime.now()),
      },
    );

    if (contestNumber != 0) {
      Response response = await _dio.get(url, options: _options);
      if (response.statusCode == 200 && response.data is Map) {
        return compute(parseResult, response.data as Map<String, dynamic>);
      }
    }
    return Future.value(LotteryAPIResult());
  }

  Future<LotteryAPIResult> fetchLatestResult(Contest contest) async {
    var url = _server + "/Loteria/${contest.getEnpoint()}/Latest";
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_contestResult,
      parameters: {
        Constants.pm_ContestName: contest.name,
        Constants.pm_ContestNumber: 'latest',
        Constants.pm_date: formatBrDateTime(DateTime.now()),
      },
    );

    Response response = await _dio.get(url, options: _options);

    if (response.statusCode == 200 && response.data is Map) {
      return compute(parseResult, response.data as Map<String, dynamic>);
    }
    return Future.value(LotteryAPIResult());
  }
}
