import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/service/generator_strategies/abstract_guess_generator.dart';
import 'package:palpites_da_loteria/service/generator_strategies/frequency_guess_generator.dart';
import 'package:palpites_da_loteria/service/generator_strategies/random_guess_generator.dart';

enum EstrategiaGeracao { ALEATORIO, MAIS_SAIDAS, MAIS_ATRASADAS }

extension EstrategiaGeracaoExtension on EstrategiaGeracao {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case EstrategiaGeracao.ALEATORIO:
        return 'Aleatório';
      case EstrategiaGeracao.MAIS_SAIDAS:
        return 'Mais frequentes';
      case EstrategiaGeracao.MAIS_ATRASADAS:
        return 'Menos frequentes';
      default:
        return '';
    }
  }

  AbstractGuessGenerator get sorteioGenerator {
    switch (this) {
      case EstrategiaGeracao.ALEATORIO:
        return RandomGuessGenerator();
      case EstrategiaGeracao.MAIS_SAIDAS:
        return FrequencyGuessGenerator(false);
      case EstrategiaGeracao.MAIS_ATRASADAS:
        return FrequencyGuessGenerator(true);
      default:
        return RandomGuessGenerator();
    }
  }
}
