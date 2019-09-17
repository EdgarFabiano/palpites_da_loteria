
import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

abstract class AbstractSorteioGenerator {

  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context);

}