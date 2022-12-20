import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../defaults/constants.dart';

class DBProvider {
  static final DBProvider _singleton = DBProvider._internal();
  Database? _db;

  factory DBProvider() {
    return _singleton;
  }

  DBProvider._internal();

  static final tableContest = 'contest';
  static final tableSavedGame = 'saved_game';

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<Database> _initDB() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, Constants.DBFileName);
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
        CREATE TABLE IF NOT EXISTS $tableContest(
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL,
          enabled BIT NOT NULL,
          color INTEGER NOT NULL, 
          spaceStart INTEGER NOT NULL, 
          spaceEnd INTEGER NOT NULL, 
          minSize INTEGER NOT NULL, 
          maxSize INTEGER NOT NULL,
          sortOrder INTEGER NOT NULL)
        ''',
        );
        await db.execute(
          '''         
        CREATE TABLE  IF NOT EXISTS $tableSavedGame(
          id INTEGER PRIMARY KEY, 
          isDone BIT NOT NULL,
          content TEXT,
          createdAt INT)
        ''',
        );
        db.batch().commit();
        print("CREATED TABLES '$tableSavedGame', '$tableContest'");
      },
    );
  }

  Future<Database> get database async {
    if (_db == null) {
      _db = await _initDB();
    }
    return Future.value(_db);
  }

}
