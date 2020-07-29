class PuzzleRecord {
  PuzzleRecord({
    this.id,
    this.puzzleName,
    this.puzzleCategory,
    this.complete,
    this.moves,
  });

  final int id;
  final String puzzleName;
  final String puzzleCategory;
  final String complete;
  final int moves;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'puzzleName': puzzleName,
      'puzzleCategory': puzzleCategory,
      'complete': complete,
      'bestMoves': moves,
    };
  }
}
