import 'package:flutter/foundation.dart';

import '../../service/generator_strategies/abstract_sorteio_generator.dart';
import '../../service/generator_strategies/frequencia_sorteio_generator.dart';
import '../../service/generator_strategies/random_sorteio_generator.dart';

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

  AbstractSorteioGenerator get sorteioGenerator {
    switch (this) {
      case EstrategiaGeracao.ALEATORIO:
        return RandomSorteioGenerator();
      case EstrategiaGeracao.MAIS_SAIDAS:
        return FrequenciaSorteioGenerator(false);
      case EstrategiaGeracao.MAIS_ATRASADAS:
        return FrequenciaSorteioGenerator(true);
      default:
        return RandomSorteioGenerator();
    }
  }
}
