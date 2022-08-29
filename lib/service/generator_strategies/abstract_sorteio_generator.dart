import 'package:flutter/material.dart';

import '../../model/concursos.dart';
import '../../model/sorteio_frequencia.dart';

abstract class AbstractSorteioGenerator {
  Future<SorteioFrequencia> sortear(ConcursoBean concurso, int gameSize,
      [DateTimeRange? dateTimeRange]);
}
