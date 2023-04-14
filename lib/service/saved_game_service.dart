import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';
import 'package:palpites_da_loteria/service/contest_service.dart';
import 'package:palpites_da_loteria/service/format_service.dart';
import 'package:sqflite/sqflite.dart';

import '../model/contest.dart';
import '../model/saved_game.dart';
import 'db_provider.dart';

class SavedGameService {
  static final SavedGameService _singleton = SavedGameService._internal();

  factory SavedGameService() {
    return _singleton;
  }

  SavedGameService._internal();

  Future<SavedGame> getSavedGameById(int id) async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons =
    await db.rawQuery('SELECT * FROM ${DBProvider.tableSavedGame} WHERE id=?', ['$id']);
    return jsons.map((json) => SavedGame.fromJsonMap(json)).toList().first;
  }

  Future<List<SavedGame>> getSavedGamesByContest(Contest? contest) async {
    Database db = await DBProvider().database;
    var sql = ' SELECT * FROM ${DBProvider.tableSavedGame} ' +
        ((contest != null)
            ? ' WHERE ${DBProvider.tableSavedGame}.contestId = ${contest.id} '
            : '') +
        ' ORDER BY ${DBProvider.tableSavedGame}.createdAt DESC ';
    final List<Map<String, dynamic>> jsons = await db.rawQuery(sql);
    return jsons.map((json) => SavedGame.fromJsonMap(json)).toList();
  }

  Future<int?> addSavedGame(SavedGame savedGame) async {
    int? savedGameId;
    if (savedGame.createdAt == null) {
      savedGame.createdAt = DateTime.now();
    }
    savedGame.numbers = getSortedNumbers(savedGame.numbers);
    Database db = await DBProvider().database;
    savedGameId = await db.insert(
      DBProvider.tableSavedGame,
      savedGame.toJsonMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    var contest = await ContestService().getContestById(savedGame.contestId);
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_addSavedGame,
      parameters: {
        Constants.pm_Contest: contest.name,
        Constants.pm_game: truncate(savedGame.numbers, 100),
        Constants.pm_title: truncate(savedGame.title ?? 'N/A', 100),
      },
    );
    return savedGameId;
  }

  Future<int?> existsSavedGame(Contest contest, List<int> dezenas) async {
    Database db = await DBProvider().database;
    var numbers = getSortedNumbers(dezenas.join('|'));
    var sql = ' SELECT id FROM ${DBProvider.tableSavedGame} ' +
        ' WHERE ${DBProvider.tableSavedGame}.contestId = ${contest.id} '
            ' AND ${DBProvider.tableSavedGame}.numbers = "$numbers"';
    final List<Map<String, dynamic>> jsons = await db.rawQuery(sql);
    if (jsons.isNotEmpty) {
      return jsons.map((json) => json['id'] as int).toList().first;
    } else {
      return null;
    }
  }

  Future<void> updateSavedGame(SavedGame savedGame) async {
    savedGame.numbers = getSortedNumbers(savedGame.numbers);
    Database db = await DBProvider().database;
    await db.update(
      DBProvider.tableSavedGame,
      savedGame.toJsonMap(),
      where: 'id = ?',
      whereArgs: [savedGame.id],
    );
  }

  Future<void> deleteSavedGameById(int id) async {
    Database db = await DBProvider().database;

    var savedGame = await getSavedGameById(id);
    var contest = await ContestService().getContestById(savedGame.contestId);
    await FirebaseAnalytics.instance.logEvent(
      name: Constants.ev_removeSavedGame,
      parameters: {
        Constants.pm_Contest: contest.name,
        Constants.pm_game: truncate(savedGame.numbers, 100),
        Constants.pm_title: truncate(savedGame.title ?? 'N/A', 100),
      },
    );

    await db.delete(
      DBProvider.tableSavedGame,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  String getSortedNumbers(String numbers) {
    var list = numbers.split("|").map((e) => int.parse(e)).toList();
    list.sort((a, b) => a.compareTo(b));
    return list.join("|");
  }
}
