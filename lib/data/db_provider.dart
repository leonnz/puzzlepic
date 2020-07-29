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
      join(await getDatabasesPath(), 'puzzle_record.db'),
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE puzzle_record(id INTEGER PRIMARY KEY, puzzleName TEXT, puzzleCategory TEXT, complete TEXT, bestMoves INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> getSingleRecord(
      {String puzzleName}) async {
    final Database db = await database;

    return db.rawQuery('SELECT * FROM puzzle_record WHERE puzzleName = ?',
        <String>[puzzleName]);
  }

  Future<void> insertRecord({PuzzleRecord record}) async {
    final Database db = await database;

    await db.insert(
      'puzzle_record',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord({int moves, String puzzleName}) async {
    final Database db = await database;
    await db.rawUpdate(
        'UPDATE puzzle_record SET bestMoves = ? WHERE puzzleName = ?',
        <dynamic>[moves, puzzleName]);
  }

  Future<List<String>> getRecords() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM puzzle_record');

    return List<String>.generate(maps.length, (int i) {
      return maps[i]['puzzleName'] as String;
    });
  }

  Future<List<String>> getRecordsByCategory({String category}) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM puzzle_record WHERE puzzleCategory = ?',
        <String>[category]);

    return List<String>.generate(maps.length, (int i) {
      return maps[i]['puzzleName'] as String;
    });
  }

  // DEV TESTING ONLY
  Future<void> deleteTable() async {
    final Database db = await database;

    await db.delete('puzzle_record');
  }
}
