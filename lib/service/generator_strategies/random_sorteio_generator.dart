import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/frequency_draw.dart';
import 'abstract_sorteio_generator.dart';

class RandomSorteioGenerator implements AbstractSorteioGenerator {

  @override
  Future<FrequencyDraw> sortear(Contest contest, int gameSize, [DateTimeRange? dateTimeRange]) {
    List<Frequency> frequencias = getFrequencias(gameSize, contest);
    List<Frequency> frequencias2 = getFrequencias(gameSize, contest);
    var sorteioFrequencia = FrequencyDraw(frequencies: frequencias, frequencies_2: frequencias2);
    return Future.value(sorteioFrequencia);
  }

  List<Frequency> getFrequencias(int gameSize, Contest contest) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(contest.spaceStart + Random().nextInt((contest.spaceEnd + 1) - contest.spaceStart)));
    }
    var frequencias = set.map((e) => Frequency(number: e)).toList();
    return frequencias;
  }

}
