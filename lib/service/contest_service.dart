import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/service/contest_initializer.dart';
import 'package:sqflite/sqflite.dart';

import '../model/contest.dart';
import 'db_provider.dart';

class ContestService {
  static final ContestService _singleton = ContestService._internal();

  factory ContestService() {
    return _singleton;
  }

  ContestService._internal();

  Future<List<Contest>> initContests() async {
    List<Contest> contests = await getContests();
    if (contests.isEmpty) {
      contests = ContestInitializer().all();
      contests.forEach(addContest);
    }
    return contests;
  }

  Future<List<Contest>> getContests() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons = await db.rawQuery(
        'SELECT * FROM ${DBProvider.tableContest} ORDER BY sortOrder');
    return jsons.map((json) => Contest.fromJson(json)).toList();
  }

  Future<Contest> getContestById(int id) async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons = await db.rawQuery(
        'SELECT * FROM ${DBProvider.tableContest} WHERE id=?', ['$id']);
    return jsons.map((json) => Contest.fromJson(json)).toList().first;
  }

  Future<List<Contest>> getActiveContests() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons = await db.rawQuery(
        'SELECT * FROM ${DBProvider.tableContest} WHERE enabled = 1 ORDER BY sortOrder');
    return jsons.map((json) => Contest.fromJson(json)).toList();
  }

  Future<List<Contest>> getContestsWithSavedGames() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons = await db.rawQuery(''
        ' SELECT * '
        ' FROM ${DBProvider.tableSavedGame} '
        ' JOIN ${DBProvider.tableContest} ON ${DBProvider.tableContest}.id = ${DBProvider.tableSavedGame}.contestId '
        ' WHERE ${DBProvider.tableContest}.enabled = 1  '
        ' GROUP BY ${DBProvider.tableContest}.id '
        ' ORDER BY ${DBProvider.tableContest}.sortOrder ASC ');
    return jsons.map((json) => Contest.fromJson(json)).toList();
  }

  Future<void> addContest(Contest contest) async {
    Database db = await DBProvider().database;
    await db.insert(
      DBProvider.tableContest,
      contest.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateOrderAndEnabledContest(Contest contest,
      {bool log = true}) async {
    Database db = await DBProvider().database;
    await db.update(
      DBProvider.tableContest,
      contest.toJson(),
      where: 'id = ?',
      whereArgs: [contest.id],
    );
    if (log) {
      await FirebaseAnalytics.instance.logEvent(
        name: Constants.ev_UpdateContestHomeScreen,
        parameters: {
          Constants.pm_Contest: contest.name,
          Constants.pm_Enabled: contest.enabled.toString(),
          Constants.pm_SortOrder: contest.sortOrder,
        },
      );
    }
  }

  Future<void> updateAllOrderAndEnabledContest(List<Contest> contests) async {
    contests.forEach((c) => updateOrderAndEnabledContest(c, log: false));
  }
}
