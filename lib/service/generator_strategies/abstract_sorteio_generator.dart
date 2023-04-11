
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/sorteio_frequencia.dart';

abstract class AbstractSorteioGenerator {

  Future<SorteioFrequencia> sortear(Contest contest, int gameSize, [DateTimeRange? dateTimeRange]);

}