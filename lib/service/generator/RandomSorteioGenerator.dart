import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/service/generator/AbstractSorteioGenerator.dart';
import 'package:palpites_da_loteria/widgets/Dezena.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      do {} while (!set.add(concurso.spaceStart + Random().nextInt(concurso.spaceEnd - concurso.spaceStart)));
    }
    return set.map((value) => Dezena(value, concurso.colorBean.getColor(context))).toList();
  }

}
