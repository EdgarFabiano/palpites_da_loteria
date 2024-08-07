import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/frequency_draw.dart';
import 'abstract_guess_generator.dart';

FrequencyDraw parseResult(Map<String, dynamic> responseBody) {
  return FrequencyDraw.fromJson(responseBody);
}

class FrequencyGuessGenerator implements AbstractGuessGenerator {
  bool isAscending;
  final String _server =
      'https://edgar.outsystemscloud.com/LoteriaService/rest/Frequencia';
  final String _username = 'loteria_service';
  final String _password = 'E862415l!';
  late String _basicAuth;

  FrequencyGuessGenerator(this.isAscending) {
    _basicAuth = 'Basic ' + base64.encode(utf8.encode('$_username:$_password'));
  }

  Future<FrequencyDraw> fetchResult(
      Contest contest, int gameSize, DateTimeRange? dateTimeRange) async {
    var url = '$_server/${contest.getEndpoint()}?IsAscending=$isAscending' +
        (dateTimeRange != null
            ? '&StartDate=${dateTimeRange.start.year}-${dateTimeRange.start.month}-${dateTimeRange.start.day}'
                '&EndDate=${dateTimeRange.end.year}-${dateTimeRange.end.month}-${dateTimeRange.end.day}'
            : '') +
        '&GameSize=$gameSize';
    http.Response response =
        await http.get(Uri.parse(url), headers: {'Authorization': _basicAuth});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return compute(
          parseResult, json.decode(response.body) as Map<String, dynamic>);
    }
    return Future.value(FrequencyDraw.empty());
  }

  @override
  Future<FrequencyDraw> generateGuess(Contest contest, int gameSize,
      [DateTimeRange? dateTimeRange]) {
    return fetchResult(contest, gameSize, dateTimeRange);
  }
}
