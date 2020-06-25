import 'dart:math';

import 'package:flutter/cupertino.dart';

class GameStateProvider with ChangeNotifier {
  static bool _gameInProgess = false;
  static String _puzzleImage = '';
  static List<Map<String, dynamic>> _piecePositions = [];
  static double _screenWidth;
  static double _singlePieceWidth = _screenWidth / _gridSideSize;
  static int _totalGridSize = 9;
  static int _blankSquare = _totalGridSize;
  static int _gridSideSize = sqrt(_totalGridSize).toInt();

  bool get getGameInProgress => _gameInProgess;
  String get getPuzzleImage => _puzzleImage;
  List<Map<String, dynamic>> get getPiecePositions => _piecePositions;
  double get getScreenWidth => _screenWidth;
  double get getSinglePieceWidth => _singlePieceWidth;
  int get getTotalGridSize => _totalGridSize;
  int get getBlankSquare => _blankSquare;
  int get getGridSideSize => _gridSideSize;

  // First index is the blank square, mapped to the moveable pieces allowed directions.
  Map<int, Map<int, String>> draggableMatrix = {
    1: {2: "left", 3: "left", 4: "up", 7: "up"},
    2: {1: "right", 3: "left", 5: "up", 8: "up"},
    3: {1: "right", 2: "right", 6: "up", 9: "up"},
    4: {1: "down", 5: "left", 6: "left", 7: "up"},
    5: {2: "down", 4: "right", 6: "left", 8: "up"},
    6: {3: "down", 4: "right", 5: "right", 9: "up"},
    7: {1: "down", 4: "down", 8: "left", 9: "left"},
    8: {2: "down", 5: "down", 7: "right", 9: "left"},
    9: {3: "down", 6: "down", 7: "right", 8: "right"},
  };

  void setGameInProgress(bool gameInProgress) {
    _gameInProgess = gameInProgress;
    // notifyListeners();
  }

  void setPuzzleImage(String puzzleImage) {
    _puzzleImage = puzzleImage;
    // notifyListeners();
  }

  double getLeftPosition(int pieceNumber) {
    return getPiecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['leftPosition'];
  }

  double getTopPosition(int pieceNumber) {
    return getPiecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['topPosition'];
  }

  void setPieceLeftPosition(int pieceNumber, double xDistance) {
    Map<String, dynamic> pieceToUpdate = getPiecePositions
        .firstWhere((imgPiece) => imgPiece['pieceNumber'] == pieceNumber);

    int piecePreviousPosition = pieceToUpdate['gridPosition'];

    double leftPosition;

    if (xDistance > 0.0) {
      leftPosition = pieceToUpdate['leftPosition'] + getSinglePieceWidth;
    } else if (xDistance < 0.0) {
      leftPosition = pieceToUpdate['leftPosition'] - getSinglePieceWidth;
    }

    pieceToUpdate['leftPosition'] = leftPosition;
    pieceToUpdate['gridPosition'] = getBlankSquare;

    setBlankSquare(piecePreviousPosition);

    print('old position $piecePreviousPosition');
    print('new position ${pieceToUpdate['gridPosition']}');

    notifyListeners();
  }

  void setPieceTopPosition(int pieceNumber, double yDistance) {
    Map<String, dynamic> pieceToUpdate = getPiecePositions
        .firstWhere((imgPiece) => imgPiece['pieceNumber'] == pieceNumber);

    // Used to set the new blank square.
    int piecePreviousPosition = pieceToUpdate['gridPosition'];

    double topPosition;

    if (yDistance > 0.0) {
      topPosition = pieceToUpdate['topPosition'] + getSinglePieceWidth;
    } else if (yDistance < 0.0) {
      topPosition = pieceToUpdate['topPosition'] - getSinglePieceWidth;
    }

    pieceToUpdate['topPosition'] = topPosition;
    pieceToUpdate['gridPosition'] = getBlankSquare;

    setBlankSquare(piecePreviousPosition);

    notifyListeners();
  }

  void setInitialPuzzlePiecePosition(int pieceNumber) {
    Map<String, dynamic> imgPiece = new Map();

    imgPiece['pieceNumber'] = pieceNumber;
    imgPiece['leftPosition'] = setStartingLeftPosition(pieceNumber);
    imgPiece['topPosition'] = setStartingTopPosition(pieceNumber);
    imgPiece['gridPosition'] = pieceNumber;
    _piecePositions.add(imgPiece);
  }

  double setStartingLeftPosition(int pieceNumber) {
    double leftPosition;
    int modulo = pieceNumber % getGridSideSize;
    if (modulo == 0) {
      leftPosition = getSinglePieceWidth * (getGridSideSize - 1);
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
    if (pieceNumber <= getGridSideSize) {
      topPosition = 0;
    } else if (pieceNumber > getGridSideSize &&
        pieceNumber <= (getGridSideSize * 2)) {
      topPosition = getSinglePieceWidth;
    } else if (pieceNumber > (getGridSideSize * 2) &&
        pieceNumber <= (getGridSideSize * 3)) {
      topPosition = getSinglePieceWidth * 2;
    } else if (pieceNumber > (getGridSideSize * 3) &&
        pieceNumber <= (getGridSideSize * 4)) {
      topPosition = getSinglePieceWidth * 3;
    } else {
      topPosition = getSinglePieceWidth * 4;
    }

    return topPosition;
  }

  void setBlankSquare(int squareNumber) {
    _blankSquare = squareNumber;
    // notifyListeners();
  }

  void setScreenWidth({double screenwidth}) {
    _screenWidth = screenwidth;
    // notifyListeners();
  }

  bool draggable({int pieceNumber, double xDistance, double yDistance}) {
    String direction;
    if (xDistance > 0.0) {
      direction = "right";
    } else if (xDistance < 0.0) {
      direction = "left";
    } else if (yDistance > 0.0) {
      direction = "down";
    } else if (yDistance < 0.0) {
      direction = "up";
    }

    List<int> draggableSquares = [];

    int piecePosition = getPiecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['gridPosition'];

    int modulo = getBlankSquare % getGridSideSize;

    // 3, 6, 9
    if (modulo == 0) {
      for (int i = 1; i <= getTotalGridSize; i++) {
        if (i % getGridSideSize == 0 && i != getBlankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = getBlankSquare - 1;
          i > getBlankSquare - getGridSideSize;
          i--) {
        draggableSquares.add(i);
      }
    }

    // 1, 4, 7
    else if (modulo == 1) {
      for (var i = 1; i < getTotalGridSize; i++) {
        if (i % getGridSideSize == 1 && i != getBlankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = getBlankSquare + 1;
          i < getBlankSquare + getGridSideSize;
          i++) {
        draggableSquares.add(i);
      }
    }

    // 2, 5, 8
    else if (modulo == 2) {
      for (var i = 1; i < getTotalGridSize; i++) {
        if (i % getGridSideSize == 2 && i != getBlankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(getBlankSquare + 1);
      draggableSquares.add(getBlankSquare - 1);
    }

    // draggableSquares.sort((a, b) => a.compareTo(b));

    if (draggableSquares.contains(piecePosition) &&
        draggableMatrix[getBlankSquare][piecePosition] == direction) {
      return true;
    }

    return false;
  }
}
