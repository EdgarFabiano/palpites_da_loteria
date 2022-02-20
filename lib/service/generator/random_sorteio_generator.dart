import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  List<int> sortear(int gameSize, ConcursoBean concurso) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart + Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart)));
    }
    return set.toList();
  }

}
