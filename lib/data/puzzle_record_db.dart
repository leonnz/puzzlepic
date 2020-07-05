import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/puzzle_record_model.dart';

class PuzzleRecordDb {
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

  Future<void> insertRecord(PuzzleRecord pr, Future<Database> database) async {
    final Database db = await database;

    await db.insert(
      'puzzle_record',
      pr.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PuzzleRecord>> getRecords(Future<Database> database) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('puzzle_record');
    await db.close();

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
