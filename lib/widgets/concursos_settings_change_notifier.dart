import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../service/contest_service.dart';

class ConcursosSettingsChangeNotifier with ChangeNotifier {
  List<Contest> _contests = [];
  ContestService? _contestService = ContestService();

  ConcursosSettingsChangeNotifier();

  getContests() => _contests;

  set contests(List<Contest> value) {
    _contests = value;
  }

  updateContest(Contest value) {
    _contestService?.updateOrderAndEnabledContest(value);
    notifyListeners();
  }

  void onReorder(int start, int current) {
    // dragging from top to bottom
    List<Contest> contests = _contests;

    if (start < current) {
      int end = current - 1;
      var startItem = contests[start];
      int i = 0;
      int local = start;
      do {
        contests[local] = contests[++local];
        i++;
      } while (i < end - start);
      contests[end] = startItem;
    }
    // dragging from bottom to top
    else if (start > current) {
      var startItem = contests[start];
      for (int i = start; i > current; i--) {
        contests[i] = contests[i - 1];
      }
      contests[current] = startItem;
    }
    for (int i = 0; i < contests.length; i++) {
      contests[i].sortOrder = i;
    }
    _contests = contests;
    _contestService?.updateAllOrderAndEnabledContest(_contests);
    notifyListeners();
  }
}
