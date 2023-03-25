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

  Future<List<SavedGame>> getSavedGames(Contest? contest) async {
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
    await db.transaction(
      (Transaction txn) async {
        savedGameId = await txn.rawInsert(
          '''
          INSERT INTO ${DBProvider.tableSavedGame}
            (contestId, createdAt, numbers)
          VALUES
            (
              ${savedGame.contestId}, 
              ${savedGame.createdAt.millisecondsSinceEpoch},
              "${savedGame.numbers}"
            )''',
        );
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
    final int count = await db.rawUpdate(
      /*sql=*/
      '''
      UPDATE ${DBProvider.tableSavedGame}
      SET numbers = ?
      WHERE id = ?''',
      /*args=*/ [savedGame.numbers, savedGame.id],
    );
    print('Updated $count records in db.');
  }

  Future<void> deleteSavedGame(SavedGame savedGame) async {
    Database db = await DBProvider().database;
    final count = await db.rawDelete(
      '''
        DELETE FROM ${DBProvider.tableSavedGame}
        WHERE id = ${savedGame.id}
      ''',
    );
    print('Deleted $count records in db.');
  }

  Future<void> deleteSavedGameById(int id) async {
    Database db = await DBProvider().database;
    final count = await db.rawDelete(
      '''
        DELETE FROM ${DBProvider.tableSavedGame}
        WHERE id = $id
      ''',
    );
    print('Deleted $count records in db.');
  }

  String getSortedNumbers(String numbers) {
    var list = numbers.split("|").map((e) => int.parse(e)).toList();
    list.sort((a, b) => a.compareTo(b));
    return list.join("|");
  }
}
