import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model-export.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart + Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart)));
    }
    return set.map((value) => Dezena(value.toString(), concurso.colorBean.getColor(context), true)).toList();
  }

}
