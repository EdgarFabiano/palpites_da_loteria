import 'package:flutter/foundation.dart';

enum FiltroPeriodo {
  TRES_MESES, SEIS_MESES, UM_ANO, TODOS, CUSTOMIZADO
}

extension FiltroPeriodoExtension on FiltroPeriodo {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case FiltroPeriodo.TRES_MESES:
        return '3 meses';
      case FiltroPeriodo.SEIS_MESES:
        return '6 meses';
      case FiltroPeriodo.UM_ANO:
        return '1 ano';
      case FiltroPeriodo.TODOS:
        return 'Desde o início';
      case FiltroPeriodo.CUSTOMIZADO:
        return 'Escolher período...';
      default:
        return '';
    }
  }

  String get labelValue {
    switch (this) {
      case FiltroPeriodo.TRES_MESES:
        return 'Dos últimos';
      case FiltroPeriodo.SEIS_MESES:
        return 'Dos últimos';
      case FiltroPeriodo.UM_ANO:
        return 'Do último';
      default:
        return '';
    }
  }

  DateTime get startDate {
    var dateTimeNow = DateTime.now();
    switch (this) {
      case FiltroPeriodo.TRES_MESES:
        return DateTime(dateTimeNow.year, dateTimeNow.month - 3, dateTimeNow.day);
      case FiltroPeriodo.SEIS_MESES:
        return DateTime(dateTimeNow.year, dateTimeNow.month - 6, dateTimeNow.day);
      case FiltroPeriodo.UM_ANO:
        return DateTime(dateTimeNow.year - 1, dateTimeNow.month, dateTimeNow.day);
      case FiltroPeriodo.TODOS:
        return DateTime(1994, 1, 1); //Não há sorteios realizados antes disso
      case FiltroPeriodo.CUSTOMIZADO:
      default:
        return dateTimeNow;
    }
  }

  DateTime get endDate {
      return DateTime.now();
  }

}