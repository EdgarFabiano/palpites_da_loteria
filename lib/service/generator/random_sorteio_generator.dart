import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

import '../../model/sorteio_frequencia.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  Future<SorteioFrequencia> sortear(int gameSize, ConcursoBean concurso) {
    List<Frequencias> frequencias = getFrequencias(gameSize, concurso);
    List<Frequencias> frequencias2 = getFrequencias(gameSize, concurso);
    var sorteioFrequencia = SorteioFrequencia(frequencias: frequencias, frequencias2: frequencias2);
    return Future.value(sorteioFrequencia);
  }

  List<Frequencias> getFrequencias(int gameSize, ConcursoBean concurso) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart + Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart)));
    }
    var frequencias = set.map((e) => Frequencias(dezena: e)).toList();
    return frequencias;
  }

}
