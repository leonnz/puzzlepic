import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'puzzle_record_model.dart';

// SQLite database that records complete puzzles
class DBProviderDb {
  factory DBProviderDb() {
    return db;
  }
  DBProviderDb._internal();

  static final DBProviderDb db = DBProviderDb._internal();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    return initDB();
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'puzzle_pic_db.db'),
      onCreate: (Database db, int version) {
        db.execute(
          'CREATE TABLE puzzle_record(id INTEGER PRIMARY KEY, puzzleName TEXT, puzzleCategory TEXT, complete TEXT, bestMoves INTEGER)',
        );
        db.execute(
          'CREATE TABLE purchase_record(id INTEGER PRIMARY KEY, imageCategoryName TEXT)',
        );
        dbcheck();
      },
      version: 1,
    );
  }

  Future<void> insertCategoryPurchasedRecord({String purchasedCategory}) async {
    final Database db = await database;

    await db.insert(
      'purchase_record',
      <String, String>{'imageCategoryName': purchasedCategory},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCategoryPurchasedRecord({String purchasedCategory}) async {
    final Database db = await database;

    await db.delete('purchase_record',
        where: 'imageCategoryName = ?', whereArgs: <String>[purchasedCategory]);
  }

  Future<List<String>> getPurchasedCategories() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT imageCategoryName FROM purchase_record');

    return List<String>.generate(maps.length, (int i) {
      return maps[i]['imageCategoryName'] as String;
    });
  }

  Future<List<Map<String, dynamic>>> getSingleRecord({String puzzleName}) async {
    final Database db = await database;

    return db.rawQuery('SELECT * FROM puzzle_record WHERE puzzleName = ?', <String>[puzzleName]);
  }

  Future<void> insertPuzzleCompleteRecord({PuzzleRecord record}) async {
    final Database db = await database;

    await db.insert(
      'puzzle_record',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord({int moves, String puzzleName}) async {
    final Database db = await database;
    await db.rawUpdate('UPDATE puzzle_record SET bestMoves = ? WHERE puzzleName = ?',
        <dynamic>[moves, puzzleName]);
  }

  Future<List<String>> getRecords() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM puzzle_record');

    return List<String>.generate(maps.length, (int i) {
      return maps[i]['puzzleName'] as String;
    });
  }

  Future<List<String>> getRecordsByCategory({String category}) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM puzzle_record WHERE puzzleCategory = ?', <String>[category]);

    return List<String>.generate(maps.length, (int i) {
      return maps[i]['puzzleName'] as String;
    });
  }

  // DEV TESTING ONLY
  Future<void> dbcheck() async {
    final String path = await getDatabasesPath();

    final Directory dir = Directory(path);

    dir.list(recursive: true, followLinks: false).listen((FileSystemEntity file) {
      print(file.path);
    });
  }

  Future<void> deleteTable() async {
    final Database db = await database;
    await db.delete('puzzle_record');
  }

  Future<void> deleteDb() async {
    final String path = join(await getDatabasesPath(), 'puzzle_pic_db.db');
    await deleteDatabase(path);

    dbcheck();
  }
}
