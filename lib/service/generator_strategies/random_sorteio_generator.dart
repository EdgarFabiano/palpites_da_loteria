import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/sorteio_frequencia.dart';
import 'abstract_sorteio_generator.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  Future<SorteioFrequencia> sortear(Contest contest, int gameSize, [DateTimeRange? dateTimeRange]) {
    List<Frequencia> frequencias = getFrequencias(gameSize, contest);
    List<Frequencia> frequencias2 = getFrequencias(gameSize, contest);
    var sorteioFrequencia = SorteioFrequencia(frequencias: frequencias, frequencias2: frequencias2);
    return Future.value(sorteioFrequencia);
  }

  List<Frequencia> getFrequencias(int gameSize, Contest contest) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(contest.spaceStart + Random().nextInt((contest.spaceEnd + 1) - contest.spaceStart)));
    }
    var frequencias = set.map((e) => Frequencia(dezena: e)).toList();
    return frequencias;
  }

}
