import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

String truncate(String? string, int maxLenght) {
  if (string == null) {
    return '';
  } else {
    return string.length > maxLenght ? string.substring(0, maxLenght) : string;
  }
}

String formatGuessNumber(String guessNumber) {
  String text = guessNumber;
  if (int.tryParse(guessNumber) != null && int.parse(guessNumber) < 10) {
    text = "0" + guessNumber;
  }
  return text;
}

String formatBrDate(DateTime? date) {
  if (date != null) {
    return formatDate(date, [dd, '/', mm, '/', yyyy]).toString();
  } else {
    return '';
  }
}

String formatBrDateTime(DateTime? date) {
  if (date != null) {
    return formatDate(date, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn, ':', ss])
        .toString();
  } else {
    return '';
  }
}

String formatNumber(dynamic valor) {
  return NumberFormat.decimalPattern('pt_BR').format(valor);
}

String formatCurrency(dynamic valor) {
  return 'R\$ ' + NumberFormat.compactLong(locale: 'pt_BR').format(valor);
}

String getDezenasResultadoDisplayValue(List<String> resultado) {
  var value = "";
  if (resultado.length <= 7) {
    resultado.forEach((element) {
      value += value == "" ? element : " | " + element;
    });
  } else {
    var count = 0;
    var iterator = resultado.iterator;
    resultado.forEach((element) {
      value += value == "" || value.endsWith("\n") ? element : " | " + element;
      count++;
      if (count >= 5) {
        count = 0;
        value += !iterator.moveNext() ? "" : "\n";
      }
    });
    value = value.substring(0, value.length - 1);
  }
  return value;
}
