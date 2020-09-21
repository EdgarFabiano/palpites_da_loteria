
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model-export.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

abstract class AbstractSorteioGenerator {

  List<Dezena> sortear(int gameSize, ConcursoBean concurso, BuildContext context);

}