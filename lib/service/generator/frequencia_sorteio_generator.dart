import 'dart:collection';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';

import '../../model/sorteio_frequencia.dart';

class FrequenciaSorteioGenerator implements AbstractSorteioGenerator {

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  @override
  Future<SorteioFrequencia> sortear(int gameSize, ConcursoBean concurso) {

    return Future.value(SorteioFrequencia(frequencias: []));
  }

}
