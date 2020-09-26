import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

String dateFormat(String date) {
  return formatDate(DateTime.parse(date), [dd, '/', mm, '/', yyyy]).toString();
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
