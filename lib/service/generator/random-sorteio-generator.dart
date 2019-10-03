import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/generator/abstract-sorteio-generator.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(concurso.spaceStart + Random().nextInt(concurso.spaceEnd - concurso.spaceStart)));
    }
    return set.map((value) => Dezena(value, concurso.colorBean.getColor(context))).toList();
  }

}