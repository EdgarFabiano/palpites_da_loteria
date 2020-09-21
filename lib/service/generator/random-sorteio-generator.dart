import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model-export.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context) {
    Set<String> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      var value = concurso.spaceStart + Random().nextInt((concurso.spaceEnd + 1) - concurso.spaceStart);
      while (!set.add(value.toString()));
    }
    return set.map((value) => Dezena(value, concurso.colorBean.getColor(context), true)).toList();
  }

}
