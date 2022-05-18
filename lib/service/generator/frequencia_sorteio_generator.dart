import 'dart:collection';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';

import '../../model/sorteio_frequencia.dart';

class FrequenciaSorteioGenerator implements AbstractSorteioGenerator {

  bool isAscending;

  FrequenciaSorteioGenerator(this.isAscending);

  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  @override
  Future<SorteioFrequencia> sortear(int gameSize, ConcursoBean concurso) {

    return Future.value(SorteioFrequencia(frequencias: [Frequencia(dezena: 1), Frequencia(dezena: 2), Frequencia(dezena: 3), Frequencia(dezena: 4), Frequencia(dezena: 5), Frequencia(dezena: 6)],
        frequencias2: [Frequencia(dezena: 1), Frequencia(dezena: 2), Frequencia(dezena: 3), Frequencia(dezena: 4), Frequencia(dezena: 5), Frequencia(dezena: 6)]));
  }

}
