

import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/domain/concursos.dart';
import 'package:palpites_da_loteria/service/concurso-service.dart';

class ConcursosSettingsChangeNotifier with ChangeNotifier {
  Concursos _concursos;

  ConcursosSettingsChangeNotifier();

  getConcursos() => _concursos;

  setConcursos(Concursos value) {
    _concursos = value;
    ConcursoService.saveConcursos(_concursos);
    notifyListeners();
  }

  void onReorder(int start, int current) {

    // dragging from top to bottom
    var concursosBeanList = _concursos.concursosBeanList;

    if (start < current) {
      int end = current - 1;
      var startItem = concursosBeanList.elementAt(start);
      int i = 0;
      int local = start;
      do {
        concursosBeanList.fillRange(local, local, concursosBeanList.elementAt(++local));
        i++;
      } while (i < end - start);
      concursosBeanList.fillRange(end, end, startItem);
    }
    // dragging from bottom to top
    else if (start > current) {
      var startItem = concursosBeanList.elementAt(start);
      for (int i = start; i > current; i--) {
        concursosBeanList.fillRange(i, i, concursosBeanList.elementAt(i-1));
      }
      concursosBeanList.fillRange(current, current, startItem);
    }
    ConcursoService.saveConcursos(_concursos);
    notifyListeners();
  }

}