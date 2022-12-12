import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/saved_game.dart';

class SavedGameService {
  static final SavedGameService _singleton = SavedGameService._internal();

  factory SavedGameService() {
    return _singleton;
  }

  SavedGameService._internal();

  static const kDbFileName = 'palpites_da_loteria.db';
  static const kDbTableName = 'saved_game';

  late Database _db;

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    this._db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY, 
          isDone BIT NOT NULL,
          content TEXT,
          createdAt INT)
        ''',
        );
      },
    );
  }

  // Retrieves rows from the db table.
  Future<List<SavedGame>> getSavedGames() async {
    final List<Map<String, dynamic>> jsons =
    await this._db.rawQuery('SELECT * FROM $kDbTableName');
    print('${jsons.length} rows retrieved from db!');
    return jsons.map((json) => SavedGame.fromJsonMap(json)).toList();
  }

  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.
  Future<void> addSavedGame(SavedGame savedGame) async {
    await this._db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO $kDbTableName
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

  // Updates records in the db table.
  Future<void> toggleSavedGame(SavedGame savedGame) async {
    final int count = await this._db.rawUpdate(
      /*sql=*/ '''
      UPDATE $kDbTableName
      SET isDone = ?
      WHERE id = ?''',
      /*args=*/ [if (savedGame.isDone) 0 else 1, savedGame.id],
    );
    print('Updated $count records in db.');
  }

  // Deletes records in the db table.
  Future<void> deleteSavedGame(SavedGame savedGame) async {
    final count = await this._db.rawDelete(
      '''
        DELETE FROM $kDbTableName
        WHERE id = ${savedGame.id}
      ''',
    );
    print('Deleted $count records in db.');
  }
}