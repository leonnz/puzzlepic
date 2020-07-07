class PuzzleRecord {
  final int id;
  final String puzzleName;
  final String puzzleCategory;
  final String complete;
  final int moves;

  PuzzleRecord({
    this.id,
    this.puzzleName,
    this.puzzleCategory,
    this.complete,
    this.moves,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'puzzleName': puzzleName,
      'puzzleCategory': puzzleCategory,
      'complete': complete,
      'bestMoves': moves,
    };
  }
}
