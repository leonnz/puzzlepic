import 'package:flutter/cupertino.dart';
import '../data/image_piece_config.dart';

class ImagePieceProvider with ChangeNotifier {
  bool draggable(
      {int pieceNumber,
      double xDistance,
      double yDistance,
      List<Map<String, dynamic>> piecePositions,
      int blankSquare,
      int gridSideSize,
      int gridSize}) {
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
}
