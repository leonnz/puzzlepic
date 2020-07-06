import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../data/image_piece_config.dart';

class GameStateProvider with ChangeNotifier {
  static bool _puzzleComplete = false;

  static Map<String, String> _image;

  static List<Map<String, dynamic>> _piecePositions = [];
  static double _screenWidth;
  static double _singlePieceWidth = _screenWidth / _gridSideSize;
  static int _totalGridSize = 16;

  static int _blankSquare = _totalGridSize;
  static int _gridSideSize = sqrt(_totalGridSize).toInt();

  // Pool of positions for random position generation.
  static List<int> _gridPositions;

  bool get getPuzzleComplete => _puzzleComplete;
  Map<String, String> get getImage => _image;
  List<Map<String, dynamic>> get getPiecePositions => _piecePositions;
  double get getScreenWidth => _screenWidth;
  double get getSinglePieceWidth => _singlePieceWidth;
  int get getTotalGridSize => _totalGridSize;
  int get getBlankSquare => _blankSquare;
  int get getGridSideSize => _gridSideSize;

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

  void setScreenWidth({double screenwidth}) {
    _screenWidth = screenwidth;
    // notifyListeners();
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

    // Checks if the piece being dragged is a multi drag piece initial drag piece.
    // Call the adjacent drag function.
    // Then we need to set its grid position to the adjacent dragged piece.
    // Otherwise this is a single piece drag so the grid position can be set to the blank square.
    if (ImagePieceConfig.draggablePieces[getBlankSquare]
        .containsKey(piecePreviousPosition)) {
      setAdjacentPieceLeftPosition(
          ImagePieceConfig.draggablePieces[getBlankSquare]
              [piecePreviousPosition],
          xDistance);

      pieceToUpdate['gridPosition'] = ImagePieceConfig
          .draggablePieces[getBlankSquare][piecePreviousPosition][0];

      setBlankSquare(piecePreviousPosition);
    } else {
      pieceToUpdate['gridPosition'] = getBlankSquare;
      setBlankSquare(piecePreviousPosition);
    }
    notifyListeners();

    checkComplete();
  }

  void setAdjacentPieceLeftPosition(
      List<int> adjacentPiecesToMove, double xDistance) {
    if (adjacentPiecesToMove.length == 1) {
      Map<String, dynamic> pieceToUpdate = getPiecePositions.firstWhere(
          (imgPiece) => imgPiece['gridPosition'] == adjacentPiecesToMove[0]);

      double leftPosition;

      if (xDistance > 0.0) {
        leftPosition = pieceToUpdate['leftPosition'] + getSinglePieceWidth;
      } else if (xDistance < 0.0) {
        leftPosition = pieceToUpdate['leftPosition'] - getSinglePieceWidth;
      }

      pieceToUpdate['leftPosition'] = leftPosition;
      pieceToUpdate['gridPosition'] = getBlankSquare;
    } else {
      for (var i = 1; i >= 0; i--) {
        Map<String, dynamic> pieceToUpdate = getPiecePositions.firstWhere(
            (imgPiece) => imgPiece['gridPosition'] == adjacentPiecesToMove[i]);

        double leftPosition;

        if (xDistance > 0.0) {
          leftPosition = pieceToUpdate['leftPosition'] + getSinglePieceWidth;
        } else if (xDistance < 0.0) {
          leftPosition = pieceToUpdate['leftPosition'] - getSinglePieceWidth;
        }

        pieceToUpdate['leftPosition'] = leftPosition;

        if (i == 1) {
          pieceToUpdate['gridPosition'] = getBlankSquare;
        } else if (i == 0) {
          pieceToUpdate['gridPosition'] = adjacentPiecesToMove[1];
        }
      }
    }
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

    // Checks if the piece being dragged is a multi drag piece initial drag piece.
    // Call the adjacent drag function.
    // Then we need to set its grid position to the adjacent dragged piece.
    // Otherwise this is a single piece drag so the grid position can be set to the blank square.
    if (ImagePieceConfig.draggablePieces[getBlankSquare]
        .containsKey(piecePreviousPosition)) {
      setAdjacentPieceTopPosition(
          ImagePieceConfig.draggablePieces[getBlankSquare]
              [piecePreviousPosition],
          yDistance);

      pieceToUpdate['gridPosition'] = ImagePieceConfig
          .draggablePieces[getBlankSquare][piecePreviousPosition][0];

      setBlankSquare(piecePreviousPosition);
    } else {
      pieceToUpdate['gridPosition'] = getBlankSquare;
      setBlankSquare(piecePreviousPosition);
    }
    notifyListeners();

    checkComplete();
  }

  void setAdjacentPieceTopPosition(
      List<int> adjacentPiecesToMove, double yDistance) {
    if (adjacentPiecesToMove.length == 1) {
      Map<String, dynamic> pieceToUpdate = getPiecePositions.firstWhere(
          (imgPiece) => imgPiece['gridPosition'] == adjacentPiecesToMove[0]);
      double topPosition;
      if (yDistance > 0.0) {
        topPosition = pieceToUpdate['topPosition'] + getSinglePieceWidth;
      } else if (yDistance < 0.0) {
        topPosition = pieceToUpdate['topPosition'] - getSinglePieceWidth;
      }

      pieceToUpdate['topPosition'] = topPosition;
      pieceToUpdate['gridPosition'] = getBlankSquare;
    } else {
      for (var i = 1; i >= 0; i--) {
        Map<String, dynamic> pieceToUpdate = getPiecePositions.firstWhere(
            (imgPiece) => imgPiece['gridPosition'] == adjacentPiecesToMove[i]);

        double topPosition;

        if (yDistance > 0.0) {
          topPosition = pieceToUpdate['topPosition'] + getSinglePieceWidth;
        } else if (yDistance < 0.0) {
          topPosition = pieceToUpdate['topPosition'] - getSinglePieceWidth;
        }

        pieceToUpdate['topPosition'] = topPosition;

        if (i == 1) {
          pieceToUpdate['gridPosition'] = getBlankSquare;
        } else if (i == 0) {
          pieceToUpdate['gridPosition'] = adjacentPiecesToMove[1];
        }
      }
    }
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
}
