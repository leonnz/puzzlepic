import 'package:sqflite/sqflite.dart';

class PuzzleRecord {
  final int id;
  final String puzzleName;
  final String complete;
  final int bestMoves;

  PuzzleRecord({this.id, this.puzzleName, this.complete, this.bestMoves});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'puzzleName': puzzleName,
      'complete': complete,
      'bestMoves': bestMoves,
    };
  }
}
