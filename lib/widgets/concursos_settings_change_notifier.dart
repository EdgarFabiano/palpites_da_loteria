

import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';
import 'package:palpites_da_loteria/service/concurso_service.dart' as concursoService;

class ConcursosSettingsChangeNotifier with ChangeNotifier {
  Concursos _concursos;

  ConcursosSettingsChangeNotifier();

  getConcursos() => _concursos;

  setConcursos(Concursos value) {
    _concursos = value;
    concursoService.saveConcursos(_concursos);
    notifyListeners();
  }

  void onReorder(int start, int current) {

    // dragging from top to bottom
    var concursosBeanList = _concursos.concursosBeanList;

    if (start < current) {
      int end = current - 1;
      var startItem = concursosBeanList[start];
      int i = 0;
      int local = start;
      do {
        concursosBeanList[local] = concursosBeanList[++local];
        i++;
      } while (i < end - start);
      concursosBeanList[end] = startItem;
    }
    // dragging from bottom to top
    else if (start > current) {
      var startItem = concursosBeanList[start];
      for (int i = start; i > current; i--) {
        concursosBeanList[i] = concursosBeanList[i - 1];
      }
      concursosBeanList[current] = startItem;
    }

    concursoService.saveConcursos(_concursos);
    notifyListeners();
  }

}