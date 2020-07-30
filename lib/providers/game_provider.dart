import 'dart:math';
import 'package:flutter/cupertino.dart';

class GameProvider with ChangeNotifier {
  static bool puzzleComplete = false;
  static Map<String, String> _image;
  static List<Map<String, dynamic>> _piecePositions = <Map<String, dynamic>>[];
  static double screenWidth;
  static const int _gridColumns = 4;
  static const int _totalGridSize = 16;
  static final double _singlePieceWidth = screenWidth / _gridColumns;

  static int blankSquare = _totalGridSize;
  static int _moves = 0;
  static int _bestMoves;
  static List<int> _gridPositions;

  // Selected puzzle data
  static String _imageCategory;
  static String _assetName;
  static String _readableName;
  static String _readableFullname;
  static String _title;

  String get getImageCategory => _imageCategory;
  String get getAssetName => _assetName;
  String get getReadableName => _readableName;
  String get getReadableFullname => _readableFullname;
  String get getTitle => _title;

  void setImageData({
    String category,
    String assetName,
    String readableName,
    String readableFullname,
    String title,
  }) {
    _imageCategory = category;
    _assetName = assetName;
    _readableName = readableName;
    _readableFullname = readableFullname;
    _title = title;
  }

  bool get getPuzzleComplete => puzzleComplete;
  Map<String, String> get getImage => _image;
  List<Map<String, dynamic>> get getPiecePositions => _piecePositions;
  double get getScreenWidth => screenWidth;
  double get getSinglePieceWidth => _singlePieceWidth;
  int get getTotalGridSize => _totalGridSize;
  int get getBlankSquare => blankSquare;
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

  void resetPiecePositions() {
    _piecePositions = <Map<String, dynamic>>[];
    blankSquare = _totalGridSize;
  }

  void setGridPositions() {
    _gridPositions = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  }

  // Check if the piece number matches its position
  void checkComplete() {
    final Iterable<bool> matching = getPiecePositions.map(
        (Map<String, dynamic> piece) =>
            piece['pieceNumber'] == piece['gridPosition']);
    if (matching.contains(false)) {
      puzzleComplete = false;
    } else {
      puzzleComplete = true;
    }
  }

  void resetGameState() {
    puzzleComplete = false;
    resetPiecePositions();
    resetMoves();
  }

  void setInitialPuzzlePiecePosition(int pieceNumber) {
    final Map<String, dynamic> imgPiece = <String, dynamic>{};

    int getRandomGridPosition(int min, int max) {
      final Random _random = Random();
      final int randomPositionIndex = min + _random.nextInt(max - min);
      final int randomNumber = _gridPositions[randomPositionIndex];

      _gridPositions.removeAt(randomPositionIndex);

      return randomNumber;
    }

    imgPiece['pieceNumber'] = pieceNumber;
    imgPiece['gridPosition'] = pieceNumber;
    imgPiece['leftPosition'] =
        setStartingLeftPosition(imgPiece['gridPosition'] as int);
    imgPiece['topPosition'] =
        setStartingTopPosition(imgPiece['gridPosition'] as int);

    // imgPiece['pieceNumber'] = pieceNumber;
    // imgPiece['gridPosition'] = getRandomGridPosition(0, _gridPositions.length);
    // imgPiece['leftPosition'] =
    //     setStartingLeftPosition(imgPiece['gridPosition']);
    // imgPiece['topPosition'] = setStartingTopPosition(imgPiece['gridPosition']);

    getPiecePositions.add(imgPiece);
  }

  double setStartingLeftPosition(int pieceNumber) {
    double leftPosition;
    final int modulo = pieceNumber % getGridColumns;
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
    } else if (pieceNumber <= (getGridColumns * 2)) {
      topPosition = getSinglePieceWidth;
    } else if (pieceNumber <= (getGridColumns * 3)) {
      topPosition = getSinglePieceWidth * 2;
    } else if (pieceNumber <= (getGridColumns * 4)) {
      topPosition = getSinglePieceWidth * 3;
    } else {
      topPosition = getSinglePieceWidth * 4;
    }

    return topPosition;
  }
}
