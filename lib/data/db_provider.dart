import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'puzzle_record_model.dart';

class DBProviderDb {
  static final DBProviderDb db = DBProviderDb._internal();

  factory DBProviderDb() {
    return db;
  }

  DBProviderDb._internal();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'puzzle_record.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE puzzle_record(id INTEGER PRIMARY KEY, puzzleName TEXT, complete TEXT, bestMoves INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertRecord(PuzzleRecord pr) async {
    final Database db = await database;

    await db.insert(
      'puzzle_record',
      pr.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PuzzleRecord>> getRecords() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('puzzle_record');

    return List.generate(maps.length, (i) {
      return PuzzleRecord(
        id: maps[i]['id'],
        puzzleName: maps[i]['puzzleName'],
        complete: maps[i]['complete'],
        bestMoves: maps[i]['bestMoves'],
      );
    });
  }
}
