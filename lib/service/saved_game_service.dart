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
            : '');
    final List<Map<String, dynamic>> jsons = await db.rawQuery(sql);
    return jsons.map((json) => SavedGame.fromJsonMap(json)).toList();
  }

  Future<void> addSavedGame(SavedGame savedGame) async {
    if (savedGame.createdAt == null) {
      savedGame.createdAt = DateTime.now();
    }
    Database db = await DBProvider().database;
    await db.transaction(
      (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO ${DBProvider.tableSavedGame}
            (contestId, createdAt, numbers)
          VALUES
            (
              ${savedGame.contestId}, 
              ${savedGame.createdAt!.millisecondsSinceEpoch},
              "${savedGame.numbers}"
            )''',
        );
        print('Inserted savedGame item with id=$id.');
      },
    );
  }

  Future<void> updateSavedGame(SavedGame savedGame) async {
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
}
