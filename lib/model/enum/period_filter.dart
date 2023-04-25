import 'package:flutter/foundation.dart';

enum PeriodFilter {
  THREE_MONTHS, SIX_MONTHS, ONE_YEAR, ALL, CUSTOM
}

extension PeriodFilterExtension on PeriodFilter {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case PeriodFilter.THREE_MONTHS:
        return '3 meses';
      case PeriodFilter.SIX_MONTHS:
        return '6 meses';
      case PeriodFilter.ONE_YEAR:
        return '1 ano';
      case PeriodFilter.ALL:
        return 'Desde o início';
      case PeriodFilter.CUSTOM:
        return 'Escolher período...';
      default:
        return '';
    }
  }

  String get labelValue {
    switch (this) {
      case PeriodFilter.THREE_MONTHS:
        return 'Dos últimos';
      case PeriodFilter.SIX_MONTHS:
        return 'Dos últimos';
      case PeriodFilter.ONE_YEAR:
        return 'Do último';
      default:
        return '';
    }
  }

  DateTime get startDate {
    var dateTimeNow = DateTime.now();
    switch (this) {
      case PeriodFilter.THREE_MONTHS:
        return DateTime(dateTimeNow.year, dateTimeNow.month - 3, dateTimeNow.day);
      case PeriodFilter.SIX_MONTHS:
        return DateTime(dateTimeNow.year, dateTimeNow.month - 6, dateTimeNow.day);
      case PeriodFilter.ONE_YEAR:
        return DateTime(dateTimeNow.year - 1, dateTimeNow.month, dateTimeNow.day);
      case PeriodFilter.ALL:
        return DateTime(1994, 1, 1); //Não há sorteios realizados antes disso
      case PeriodFilter.CUSTOM:
      default:
        return dateTimeNow;
    }
  }

  DateTime get endDate {
      return DateTime.now();
  }

}