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

  static String _imageCategoryAssetName;
  static String _imageCategoryReadableName;
  static String _imageAssetName;
  static String _imageReadableName;
  static String _imageReadableFullname;
  static String _imageTitle;

  String get getImageCategoryAssetName => _imageCategoryAssetName;
  String get getImageCategoryReadableName => _imageCategoryReadableName;
  String get getImageAssetName => _imageAssetName;
  String get getImageReadableName => _imageReadableName;
  String get getImageReadableFullname => _imageReadableFullname;
  String get getImageTitle => _imageTitle;

  void setSelectedCategory({String assetName, String readableName}) {
    _imageCategoryAssetName = assetName;
    _imageCategoryReadableName = readableName;
  }

  void setImageData(
      {String assetName, String readableName, String readableFullname, String title}) {
    _imageAssetName = assetName;
    _imageReadableName = readableName;
    _imageReadableFullname = readableFullname;
    _imageTitle = title;
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

  void checkComplete() {
    final Iterable<bool> matching = getPiecePositions
        .map((Map<String, dynamic> piece) => piece['pieceNumber'] == piece['gridPosition']);
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

    // DEV ONLY pieces are already in right position
    imgPiece['pieceNumber'] = pieceNumber;
    imgPiece['gridPosition'] = pieceNumber;
    imgPiece['leftPosition'] = setStartingLeftPosition(imgPiece['gridPosition'] as int);
    imgPiece['topPosition'] = setStartingTopPosition(imgPiece['gridPosition'] as int);

    // imgPiece['pieceNumber'] = pieceNumber;
    // imgPiece['gridPosition'] = getRandomGridPosition(0, _gridPositions.length);
    // imgPiece['leftPosition'] = setStartingLeftPosition(imgPiece['gridPosition'] as int);
    // imgPiece['topPosition'] = setStartingTopPosition(imgPiece['gridPosition'] as int);

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
