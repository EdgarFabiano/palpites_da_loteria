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
    final List<Map<String, dynamic>> jsons =
        await db.rawQuery('SELECT * FROM ${DBProvider.tableContest} ORDER BY sortOrder');
    return jsons.map((json) => Contest.fromJson(json)).toList();
  }

  Future<List<Contest>> getActiveContests() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons =
    await db.rawQuery('SELECT * FROM ${DBProvider.tableContest} WHERE enabled = 1 ORDER BY sortOrder');
    return jsons.map((json) => Contest.fromJson(json)).toList();
  }

  Future<List<Contest>> getContestsWithSavedGames() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons =
    await db.rawQuery(''
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

  Future<void> updateOrderAndEnabledContest(Contest contest) async {
    Database db = await DBProvider().database;
    await db.update(
      DBProvider.tableContest,
      contest.toJson(),
      where: 'id = ?',
      whereArgs: [contest.id],
    );
  }

  Future<void> updateAllOrderAndEnabledContest(List<Contest> contest) async {
    contest.forEach(updateOrderAndEnabledContest);
  }
}
