import 'dart:math';
import 'package:flutter/cupertino.dart';

class GameProvider with ChangeNotifier {
  static bool _puzzleComplete = false;
  static Map<String, String> _image;
  static List<Map<String, dynamic>> _piecePositions = [];
  static double _screenWidth;
  static int _gridColumns = 4;
  static int _totalGridSize = 16;
  static double _singlePieceWidth = _screenWidth / _gridColumns;

  static int _blankSquare = _totalGridSize;
  static int _moves = 0;
  static int _bestMoves;
  static List<int> _gridPositions;

  // Selected puzzle data

  bool get getPuzzleComplete => _puzzleComplete;
  Map<String, String> get getImage => _image;
  List<Map<String, dynamic>> get getPiecePositions => _piecePositions;
  double get getScreenWidth => _screenWidth;
  double get getSinglePieceWidth => _singlePieceWidth;
  int get getTotalGridSize => _totalGridSize;
  int get getBlankSquare => _blankSquare;
  int get getGridColumns => _gridColumns;
  int get getMoves => _moves;
  int get getBestMoves => _bestMoves;
  List<int> get getGridPositions => _gridPositions;

  void setMoves() {
    _moves += 1;
    notifyListeners();
  }

  void setBestMoves({int moves}) {
    _bestMoves = moves;
    notifyListeners();
  }

  void resetMoves() {
    _moves = 0;
    notifyListeners();
  }

  void setPuzzleComplete(bool complete) {
    _puzzleComplete = complete;
  }

  void resetPiecePositions() {
    _piecePositions = [];
    setBlankSquare(_totalGridSize);
  }

  void setGridPositions() {
    _gridPositions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  }

  void setScreenWidth({double width}) {
    _screenWidth = width;
  }

  // Check if the piece number matches its position
  void checkComplete() {
    var matching = getPiecePositions
        .map((piece) => piece['pieceNumber'] == piece['gridPosition']);
    if (matching.contains(false)) {
      setPuzzleComplete(false);
    } else {
      setPuzzleComplete(true);
    }
  }

  void resetGameState() {
    setPuzzleComplete(false);
    resetPiecePositions();
    resetMoves();
  }

  void setInitialPuzzlePiecePosition(int pieceNumber) {
    Map<String, dynamic> imgPiece = new Map();

    List<int> allocatedGridPositions = [];

    getPiecePositions.forEach((piece) {
      allocatedGridPositions.add(piece['gridPosition']);
    });

    int getRandomGridPosition(int min, int max) {
      final _random = new Random();
      int randomPositionIndex = min + _random.nextInt(max - min);
      int randomNumber = _gridPositions[randomPositionIndex];

      _gridPositions.removeAt(randomPositionIndex);

      return randomNumber;
    }

    imgPiece['pieceNumber'] = pieceNumber;
    imgPiece['gridPosition'] = pieceNumber;
    imgPiece['leftPosition'] =
        setStartingLeftPosition(imgPiece['gridPosition']);
    imgPiece['topPosition'] = setStartingTopPosition(imgPiece['gridPosition']);

    // imgPiece['pieceNumber'] = pieceNumber;
    // imgPiece['gridPosition'] = getRandomGridPosition(0, _gridPositions.length);
    // imgPiece['leftPosition'] =
    //     setStartingLeftPosition(imgPiece['gridPosition']);
    // imgPiece['topPosition'] = setStartingTopPosition(imgPiece['gridPosition']);

    getPiecePositions.add(imgPiece);
  }

  double setStartingLeftPosition(int pieceNumber) {
    double leftPosition;
    int modulo = pieceNumber % getGridColumns;
    if (modulo == 0) {
      leftPosition = getSinglePieceWidth * (getGridColumns - 1);
    } else if (modulo == 1) {
      leftPosition = 0;
    } else if (modulo == 2) {
      leftPosition = getSinglePieceWidth;
    } else if (modulo == 3) {
      leftPosition = getSinglePieceWidth * 2;
    } else if (modulo == 4) {
      leftPosition = getSinglePieceWidth * 3;
    }

    return leftPosition;
  }

  double setStartingTopPosition(int pieceNumber) {
    double topPosition;
    if (pieceNumber <= getGridColumns) {
      topPosition = 0;
    } else if (pieceNumber > getGridColumns &&
        pieceNumber <= (getGridColumns * 2)) {
      topPosition = getSinglePieceWidth;
    } else if (pieceNumber > (getGridColumns * 2) &&
        pieceNumber <= (getGridColumns * 3)) {
      topPosition = getSinglePieceWidth * 2;
    } else if (pieceNumber > (getGridColumns * 3) &&
        pieceNumber <= (getGridColumns * 4)) {
      topPosition = getSinglePieceWidth * 3;
    } else {
      topPosition = getSinglePieceWidth * 4;
    }

    return topPosition;
  }

  void setBlankSquare(int squareNumber) {
    _blankSquare = squareNumber;
  }
}
