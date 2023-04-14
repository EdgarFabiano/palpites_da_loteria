import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../defaults/constants.dart';
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

  Future<void> onReorder(int start, int current) async {
    var from = start, to = current;
    // dragging from top to bottom
    List<Contest> contests = _contests;
    var contest = contests[from].name, enabled = contests[from].enabled;

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

    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_SortContestHomeScreen,
      parameters: {
        Constants.pm_Contest: contest,
        Constants.pm_from: from,
        Constants.pm_to: to,
        Constants.pm_Enabled: enabled.toString(),
      },
    );
  }
}
