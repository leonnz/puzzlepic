import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
}
