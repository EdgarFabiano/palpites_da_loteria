import 'package:sqflite/sqflite.dart';

import '../model/saved_game.dart';
import 'db_provider.dart';

class SavedGameService {
  static final SavedGameService _singleton = SavedGameService._internal();

  factory SavedGameService() {
    return _singleton;
  }

  SavedGameService._internal();

  Future<List<SavedGame>> getSavedGames() async {
    Database db = await DBProvider().database;
    final List<Map<String, dynamic>> jsons =
    await db.rawQuery('SELECT * FROM ${DBProvider.tableSavedGame}');
    print('${jsons.length} rows retrieved from db!');
    return jsons.map((json) => SavedGame.fromJsonMap(json)).toList();
  }

  Future<void> addSavedGame(SavedGame savedGame) async {
    Database db = await DBProvider().database;
    await db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO ${DBProvider.tableSavedGame}
            (content, isDone, createdAt)
          VALUES
            (
              "${savedGame.content}",
              ${savedGame.isDone ? 1 : 0}, 
              ${savedGame.createdAt.millisecondsSinceEpoch}
            )''',
        );
        print('Inserted savedGame item with id=$id.');
      },
    );
  }

  Future<void> toggleSavedGame(SavedGame savedGame) async {
    Database db = await DBProvider().database;
    final int count = await db.rawUpdate(
      /*sql=*/ '''
      UPDATE ${DBProvider.tableSavedGame}
      SET isDone = ?
      WHERE id = ?''',
      /*args=*/ [if (savedGame.isDone) 0 else 1, savedGame.id],
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