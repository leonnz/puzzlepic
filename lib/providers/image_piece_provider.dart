import 'package:flutter/cupertino.dart';
import '../data/image_piece_config.dart';

class ImagePieceProvider with ChangeNotifier {
  double getLeftPosition({
    int pieceNumber,
    List<Map<String, dynamic>> piecePositions,
  }) {
    return piecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['leftPosition'];
  }

  double getTopPosition({
    int pieceNumber,
    List<Map<String, dynamic>> piecePositions,
  }) {
    return piecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['topPosition'];
  }

  bool draggable({
    int pieceNumber,
    double xDistance,
    double yDistance,
    List<Map<String, dynamic>> piecePositions,
    int blankSquare,
    int gridSideSize,
    int gridSize,
  }) {
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

    int piecePosition = piecePositions.firstWhere(
        (imgPiece) => imgPiece['pieceNumber'] == pieceNumber)['gridPosition'];

    int modulo = blankSquare % gridSideSize;

    // 4, 8, 12, 16
    if (modulo == 0) {
      for (int i = 1; i <= gridSize; i++) {
        if (i % gridSideSize == 0 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = blankSquare - 1; i > blankSquare - gridSideSize; i--) {
        draggableSquares.add(i);
      }
    }

    // 1, 5, 9, 13
    else if (modulo == 1) {
      for (var i = 1; i < gridSize; i++) {
        if (i % gridSideSize == 1 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = blankSquare + 1; i < blankSquare + gridSideSize; i++) {
        draggableSquares.add(i);
      }
    }

    // 2, 6, 10, 14
    else if (modulo == 2) {
      for (var i = 1; i < gridSize; i++) {
        if (i % gridSideSize == 2 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(blankSquare + 1);
      draggableSquares.add(blankSquare + 2);
      draggableSquares.add(blankSquare - 1);
    }

    // 3, 7, 11, 15
    else if (modulo == 3) {
      for (var i = 0; i < gridSize; i++) {
        if (i % gridSideSize == 3 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(blankSquare + 1);
      draggableSquares.add(blankSquare - 1);
      draggableSquares.add(blankSquare - 2);
    }

    draggableSquares.sort((a, b) => a.compareTo(b));

    if (draggableSquares.contains(piecePosition) &&
        ImagePieceConfig.draggableDirections[blankSquare][piecePosition] ==
            direction) {
      return true;
    }

    return false;
  }

  void setPieceLeftPosition({
    int pieceNumber,
    double xDistance,
    List<Map<String, dynamic>> getPiecePositions,
    double getSinglePieceWidth,
    int getBlankSquare,
    Function setBlankSquare,
    Function checkComplete,
  }) {
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
        adjacentPiecesToMove: ImagePieceConfig.draggablePieces[getBlankSquare]
            [piecePreviousPosition],
        getBlankSquare: getBlankSquare,
        getPiecePositions: getPiecePositions,
        getSinglePieceWidth: getSinglePieceWidth,
        xDistance: xDistance,
      );

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

  void setAdjacentPieceLeftPosition({
    List<int> adjacentPiecesToMove,
    double xDistance,
    List<Map<String, dynamic>> getPiecePositions,
    double getSinglePieceWidth,
    int getBlankSquare,
  }) {
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

  void setPieceTopPosition({
    int pieceNumber,
    double yDistance,
    List<Map<String, dynamic>> getPiecePositions,
    double getSinglePieceWidth,
    int getBlankSquare,
    Function setBlankSquare,
    Function checkComplete,
  }) {
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
        adjacentPiecesToMove: ImagePieceConfig.draggablePieces[getBlankSquare]
            [piecePreviousPosition],
        getBlankSquare: getBlankSquare,
        getPiecePositions: getPiecePositions,
        getSinglePieceWidth: getSinglePieceWidth,
        yDistance: yDistance,
      );

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

  void setAdjacentPieceTopPosition({
    List<int> adjacentPiecesToMove,
    double yDistance,
    List<Map<String, dynamic>> getPiecePositions,
    double getSinglePieceWidth,
    int getBlankSquare,
  }) {
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
}
