import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/service/generator_strategies/abstract_guess_generator.dart';
import 'package:palpites_da_loteria/service/generator_strategies/frequency_guess_generator.dart';
import 'package:palpites_da_loteria/service/generator_strategies/random_guess_generator.dart';

enum GenerationStrategy { RANDOM, MORE_FREQUENT, LESS_FREQUENT }

extension GenerationStrategyExtension on GenerationStrategy {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case GenerationStrategy.RANDOM:
        return 'Aleatório';
      case GenerationStrategy.MORE_FREQUENT:
        return 'Mais frequentes';
      case GenerationStrategy.LESS_FREQUENT:
        return 'Menos frequentes';
      default:
        return '';
    }
  }

  AbstractGuessGenerator get guessGenerator {
    switch (this) {
      case GenerationStrategy.RANDOM:
        return RandomGuessGenerator();
      case GenerationStrategy.MORE_FREQUENT:
        return FrequencyGuessGenerator(false);
      case GenerationStrategy.LESS_FREQUENT:
        return FrequencyGuessGenerator(true);
      default:
        return RandomGuessGenerator();
    }
  }
}
