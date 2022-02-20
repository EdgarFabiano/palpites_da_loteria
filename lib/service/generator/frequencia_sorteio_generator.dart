import 'dart:collection';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class FrequenciaSorteioGenerator implements AbstractSorteioGenerator {

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  @override
  List<int> sortear(int gameSize, ConcursoBean concurso) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart + Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart)));
    }
    return set.toList();
  }

}
