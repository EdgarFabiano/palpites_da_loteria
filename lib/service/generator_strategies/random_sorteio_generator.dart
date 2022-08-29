import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../model/concursos.dart';
import '../../model/sorteio_frequencia.dart';
import 'abstract_sorteio_generator.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {
  @override
  Future<SorteioFrequencia> sortear(ConcursoBean concurso, int gameSize,
      [DateTimeRange? dateTimeRange]) {
    List<Frequencia> frequencias = getFrequencias(gameSize, concurso);
    List<Frequencia> frequencias2 = getFrequencias(gameSize, concurso);
    var sorteioFrequencia =
        SorteioFrequencia(frequencias: frequencias, frequencias2: frequencias2);
    return Future.value(sorteioFrequencia);
  }

  List<Frequencia> getFrequencias(int gameSize, ConcursoBean concurso) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart +
          Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart)));
    }
    var frequencias = set.map((e) => Frequencia(dezena: e)).toList();
    return frequencias;
  }
}
