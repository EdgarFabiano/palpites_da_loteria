
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/sorteio_frequencia.dart';

abstract class AbstractSorteioGenerator {

  Future<SorteioFrequencia> sortear(int gameSize, ConcursoBean concurso);

}