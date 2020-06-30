import 'dart:math';

import 'package:flutter/cupertino.dart';

class GameStateProvider with ChangeNotifier {
  static bool _puzzleComplete = false;
  static String _puzzleImage = '';
  static String _imageName = '';
  static List<Map<String, dynamic>> _piecePositions = [];
  static double _screenWidth;
  static double _singlePieceWidth = _screenWidth / _gridSideSize;
  static int _totalGridSize = 16;

  static int _blankSquare = _totalGridSize;
  static int _gridSideSize = sqrt(_totalGridSize).toInt();

  // Pool of positions for random position generation.
  static List<int> _gridPositions;

  bool get getPuzzleComplete => _puzzleComplete;
  String get getPuzzleImage => _puzzleImage;
  String get getImageName => _imageName;
  List<Map<String, dynamic>> get getPiecePositions => _piecePositions;
  double get getScreenWidth => _screenWidth;
  double get getSinglePieceWidth => _singlePieceWidth;
  int get getTotalGridSize => _totalGridSize;
  int get getBlankSquare => _blankSquare;
  int get getGridSideSize => _gridSideSize;

  // First index is the blank square, mapped to the moveable pieces allowed directions.
  Map<int, Map<int, String>> draggableMatrix = {
    1: {
      2: "left",
      3: "left",
      4: "left",
      5: "up",
      9: "up",
      13: "up",
    },
    2: {
      1: "right",
      3: "left",
      4: "left",
      6: "up",
      10: "up",
      14: "up",
    },
    3: {
      1: "right",
      2: "right",
      4: "left",
      7: "up",
      11: "up",
      15: "up",
    },
    4: {
      1: "right",
      2: "right",
      3: "right",
      8: "up",
      12: "up",
      16: "up",
    },
    5: {
      1: "down",
      6: "left",
      7: "left",
      8: "left",
      9: "up",
      13: "up",
    },
    6: {
      2: "down",
      5: "right",
      7: "left",
      8: "left",
      10: "up",
      14: "up",
    },
    7: {
      3: "down",
      5: "right",
      6: "right",
      8: "left",
      11: "up",
      15: "up",
    },
    8: {
      4: "down",
      5: "right",
      6: "right",
      7: "right",
      12: "up",
      16: "up",
    },
    9: {
      1: "down",
      5: "down",
      10: "left",
      11: "left",
      12: "left",
      13: "up",
    },
    10: {
      2: "down",
      6: "down",
      9: "right",
      11: "left",
      12: "left",
      14: "up",
    },
    11: {
      3: "down",
      7: "down",
      9: "right",
      10: "right",
      12: "left",
      15: "up",
    },
    12: {
      4: "down",
      8: "down",
      9: "right",
      10: "right",
      11: "right",
      16: "up",
    },
    13: {
      1: "down",
      5: "down",
      9: "down",
      14: "left",
      15: "left",
      16: "left",
    },
    14: {
      2: "down",
      6: "down",
      10: "down",
      13: "right",
      15: "left",
      16: "left",
    },
    15: {
      3: "down",
      7: "down",
      11: "down",
      13: "right",
      14: "right",
      16: "left",
    },
    16: {
      4: "down",
      8: "down",
      12: "down",
      13: "right",
      14: "right",
      15: "right",
    },
  };

  // First index is the blank square, mapped to the moveable pieces
  // and the adjacent pieces that need to move with it.
  Map<int, Map<int, List<int>>> draggableMatrixMulti = {
    1: {
      3: [2],
      4: [3, 2],
      9: [5],
      13: [9, 5],
    },
    2: {
      4: [3],
      10: [6],
      14: [10, 6],
    },
    3: {
      1: [2],
      11: [7],
      15: [11, 7],
    },
    4: {
      1: [2, 3],
      2: [3],
      12: [8],
      16: [12, 8],
    },
    5: {
      7: [6],
      8: [7, 6],
      13: [9],
    },
    6: {
      8: [7],
      14: [10],
    },
    7: {
      5: [6],
      15: [11],
    },
    8: {
      5: [6, 7],
      6: [7],
      16: [12],
    },
    9: {
      1: [5],
      11: [10],
      12: [11, 10],
    },
    10: {
      2: [6],
      12: [11],
    },
    11: {
      3: [7],
      9: [10],
    },
    12: {
      4: [8],
      9: [10, 11],
      10: [11]
    },
    13: {
      1: [5, 9],
      5: [9],
      15: [14],
      16: [15, 14],
    },
    14: {
      2: [6, 10],
      6: [10],
      16: [15],
    },
    15: {
      3: [7, 11],
      7: [11],
      13: [14]
    },
    16: {
      4: [8, 12],
      8: [12],
      13: [14, 15],
      14: [15]
    },
  };

  void setPuzzleComplete(bool complete) {
    _puzzleComplete = complete;
    // notifyListeners();
  }

  void setPuzzleImage(String puzzleImage) {
    _puzzleImage = puzzleImage;
    // notifyListeners();
  }

  void setImageName(String image) {
    _imageName =
        image.substring(image.lastIndexOf('/') + 1, image.lastIndexOf('.jpg'));
  }

  void setGridPositions() {
    _gridPositions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  }

  double getLeftPosition(int pieceNumber) {
    return getPiecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['leftPosition'];
  }

  double getTopPosition(int pieceNumber) {
    return getPiecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['topPosition'];
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
    if (draggableMatrixMulti[getBlankSquare]
        .containsKey(piecePreviousPosition)) {
      setAdjacentPieceLeftPosition(
          draggableMatrixMulti[getBlankSquare][piecePreviousPosition],
          xDistance);

      pieceToUpdate['gridPosition'] =
          draggableMatrixMulti[getBlankSquare][piecePreviousPosition][0];

      setBlankSquare(piecePreviousPosition);
    } else {
      pieceToUpdate['gridPosition'] = getBlankSquare;
      setBlankSquare(piecePreviousPosition);
    }

    checkComplete();
    notifyListeners();
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

    // Checks if the piece being dragged is a multi drag piece initial drag piece.
    // Call the adjacent drag function.
    // Then we need to set its grid position to the adjacent dragged piece.
    // Otherwise this is a single piece drag so the grid position can be set to the blank square.
    if (draggableMatrixMulti[getBlankSquare]
        .containsKey(piecePreviousPosition)) {
      setAdjacentPieceTopPosition(
          draggableMatrixMulti[getBlankSquare][piecePreviousPosition],
          yDistance);

      pieceToUpdate['gridPosition'] =
          draggableMatrixMulti[getBlankSquare][piecePreviousPosition][0];

      setBlankSquare(piecePreviousPosition);
    } else {
      pieceToUpdate['gridPosition'] = getBlankSquare;
      setBlankSquare(piecePreviousPosition);
    }

    checkComplete();
    notifyListeners();
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

    notifyListeners();
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

    // 4, 8, 12, 16
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

    // 1, 5, 9, 13
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

    // 2, 6, 10, 14
    else if (modulo == 2) {
      for (var i = 1; i < getTotalGridSize; i++) {
        if (i % getGridSideSize == 2 && i != getBlankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(getBlankSquare + 1);
      draggableSquares.add(getBlankSquare + 2);
      draggableSquares.add(getBlankSquare - 1);
    }

    // 3, 7, 11, 15
    else if (modulo == 3) {
      for (var i = 0; i < getTotalGridSize; i++) {
        if (i % getGridSideSize == 3 && i != getBlankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(getBlankSquare + 1);
      draggableSquares.add(getBlankSquare - 1);
      draggableSquares.add(getBlankSquare - 2);
    }

    draggableSquares.sort((a, b) => a.compareTo(b));

    if (draggableSquares.contains(piecePosition) &&
        draggableMatrix[getBlankSquare][piecePosition] == direction) {
      return true;
    }

    return false;
  }
}
