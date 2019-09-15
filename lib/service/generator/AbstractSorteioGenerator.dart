
import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/domain/Concursos.dart';
import 'package:palpites_da_loteria/widgets/Dezena.dart';

abstract class AbstractSorteioGenerator {

  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context);

}