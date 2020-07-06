import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'puzzle_record_model.dart';

// SQLite database that records complete puzzles
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
          "CREATE TABLE puzzle_record(id INTEGER PRIMARY KEY, puzzleName TEXT, puzzleCategory TEXT, complete TEXT, bestMoves INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> getSingleRecord(
      {String puzzleName}) async {
    final Database db = await database;

    return await db.rawQuery(
        'SELECT * FROM puzzle_record WHERE puzzleName = ?', [puzzleName]);
  }

  Future<void> insertRecord(PuzzleRecord record) async {
    final Database db = await database;

    List<String> currentRecords = await getRecords();

    // print('current record $currentRecords');

    if (currentRecords.contains(record.puzzleName)) {
      // Get the current record
      var existingRecord = await getSingleRecord(puzzleName: record.puzzleName);

      print('existingRecord: $existingRecord');
      // Update the best moves if lower

      // if(record.bestMoves < existingRecord.toList()[0]) {

      // }
      // await db.rawUpdate(
      //     'UPDATE puzzle_record SET bestMoves = ? WHERE puzzleName = ?',
      //     [record.bestMoves]);
    } else {
      print('here');
      await db.insert(
        'puzzle_record',
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<String>> getRecords() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM puzzle_record');

    return List.generate(maps.length, (i) {
      return maps[i]['puzzleName'];
    });
  }

  Future<List<String>> getRecordsByCategory({String category}) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM puzzle_record WHERE puzzleCategory = ?', [category]);

    return List.generate(maps.length, (i) {
      return maps[i]['puzzleName'];
    });
  }

  // DEV TESTING ONLY
  void deleteTable() async {
    final Database db = await database;

    await db.delete('puzzle_record');
  }
}
