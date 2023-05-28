import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/frequency_draw.dart';
import 'abstract_guess_generator.dart';

class RandomGuessGenerator implements AbstractGuessGenerator {
  @override
  Future<FrequencyDraw> generateGuess(Contest contest, int gameSize,
      [DateTimeRange? dateTimeRange]) {
    var frequencies = getFrequencies(gameSize, contest);
    var frequencies_2 = getFrequencies(gameSize, contest);
    var frequencyDraw =
        FrequencyDraw(frequencies: frequencies, frequencies_2: frequencies_2);
    return Future.value(frequencyDraw);
  }

  List<Frequency> getFrequencies(int gameSize, Contest contest) {
    Set<int> set = SplayTreeSet();
    for (int i = 0; i < gameSize; i++) {
      while (!set.add(contest.spaceStart +
          Random().nextInt((contest.spaceEnd + 1) - contest.spaceStart)));
    }
    return set.map((e) => Frequency(number: e)).toList();
  }
}
