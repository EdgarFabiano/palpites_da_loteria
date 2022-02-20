
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/widgets/dezena.dart';

abstract class AbstractSorteioGenerator {

  List<int> sortear(int gameSize, ConcursoBean concurso);

}