
import 'package:flutter/foundation.dart';
import 'package:palpites_da_loteria/service/generator/abstract_sorteio_generator.dart';
import 'package:palpites_da_loteria/service/generator/frequencia_sorteio_generator.dart';
import 'package:palpites_da_loteria/service/generator/random_sorteio_generator.dart';

enum EstrategiaGeracao {
  ALEATORIO, MAIS_SAIDAS, MAIS_ATRASADAS
}

extension EstrategiaGeracaoExtension on EstrategiaGeracao {
  String get name => describeEnum(this);
  String get displayTitle {
    switch (this) {
      case EstrategiaGeracao.ALEATORIO:
        return 'Aleatório';
      case EstrategiaGeracao.MAIS_SAIDAS:
        return 'Mais saídas';
      case EstrategiaGeracao.MAIS_ATRASADAS:
        return 'Mais atrasadas';
      default:
        return '';
    }
  }

  AbstractSorteioGenerator get sorteioGenerator {
    switch (this) {
      case EstrategiaGeracao.ALEATORIO:
        return RandomSorteioGenerator();
      case EstrategiaGeracao.MAIS_SAIDAS:
        return FrequenciaSorteioGenerator(true);
      case EstrategiaGeracao.MAIS_ATRASADAS:
        return FrequenciaSorteioGenerator(false);
      default:
        return RandomSorteioGenerator();
    }
  }
}