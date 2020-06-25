import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gameStateProvider.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    this.image,
    this.initialPieceNumber,
    this.gridPieces,
    this.gridSideSize,
    this.singlePieceWidth,
    this.offsetCallback,
  }) : super(key: key);

  final String image;
  final int initialPieceNumber;
  final int gridPieces;
  final int gridSideSize;
  final double singlePieceWidth;
  final Function(int, Offset) offsetCallback;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  final GlobalKey _pieceKey = GlobalKey();
  double xDistance = 0.0;
  double yDistance = 0.0;
  double initial = 0.0;
  bool draggedX = false;
  bool draggedY = false;

  int gridColumnsRows;
  int modulo;

// TODO Update this position value after dragged.
  int positionOnGrid;

  double leftPosition;
  double topPosition;

  @override
  void initState() {
    super.initState();

    positionOnGrid = widget.initialPieceNumber;

    leftPosition = calculateStartingLeftPosition(
      // TODO if the puzzle piece exists in provider use that left position
      imagePieceNumber: widget.initialPieceNumber,
      gridSideSize: widget.gridSideSize,
      singlePieceWidth: widget.singlePieceWidth,
    );

    topPosition = calculateStartingTopPosition(
      imagePieceNumber: widget.initialPieceNumber,
      gridSideSize: widget.gridSideSize,
      singlePieceWidth: widget.singlePieceWidth,
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getPosition(widget.initialPieceNumber));
  }

  double calculateStartingLeftPosition(
      {int imagePieceNumber, int gridSideSize, double singlePieceWidth}) {
    double leftPosition;
    int modulo = imagePieceNumber % gridSideSize;
    if (modulo == 0) {
      leftPosition = singlePieceWidth * (gridSideSize - 1);
    } else if (modulo == 1) {
      leftPosition = 0;
    } else if (modulo == 2) {
      leftPosition = singlePieceWidth;
    } else if (modulo == 3) {
      leftPosition = singlePieceWidth * 2;
    } else if (modulo == 4) {
      leftPosition = singlePieceWidth * 3;
    }

    // final gameStateData =
    //     Provider.of<GameStateProvider>(context, listen: false);

    // gameStateData.setPuzzleImagePieceLeftPosition(
    //   imagePiecenumber: widget.initialPieceNumber,
    //   leftPosition: leftPosition,
    // );

    return leftPosition;
  }

  double calculateStartingTopPosition(
      {int imagePieceNumber, int gridSideSize, double singlePieceWidth}) {
    double topPosition;
    if (imagePieceNumber <= gridSideSize) {
      topPosition = 0;
    } else if (imagePieceNumber > gridSideSize &&
        imagePieceNumber <= (gridSideSize * 2)) {
      topPosition = singlePieceWidth;
    } else if (imagePieceNumber > (gridSideSize * 2) &&
        imagePieceNumber <= (gridSideSize * 3)) {
      topPosition = singlePieceWidth * 2;
    } else if (imagePieceNumber > (gridSideSize * 3) &&
        imagePieceNumber <= (gridSideSize * 4)) {
      topPosition = singlePieceWidth * 3;
    } else {
      topPosition = singlePieceWidth * 4;
    }

    return topPosition;
  }

  getPosition(int p) {
    RenderBox _piece1Box = _pieceKey.currentContext.findRenderObject();
    Offset position = _piece1Box.localToGlobal(Offset.zero);
    widget.offsetCallback(
        widget.initialPieceNumber, Offset(leftPosition, topPosition));
  }

  bool draggable() {
    if (xDistance > 0.0) {
      print('right');
    } else if (xDistance < 0.0) {
      print('left');
    } else if (yDistance > 0.0) {
      print('down');
    } else if (yDistance < 0.0) {
      print('up');
    }

    List<int> draggableSquares = [];
    final gameStateData =
        Provider.of<GameStateProvider>(context, listen: false);
    final blankSquare = gameStateData.getBlankSquare;

    print(blankSquare);

    int modulo = blankSquare % gridColumnsRows;

    // 3, 6, 9
    if (modulo == 0) {
      for (int i = 1; i <= widget.gridPieces; i++) {
        if (i % gridColumnsRows == 0 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = blankSquare - 1; i > blankSquare - gridColumnsRows; i--) {
        draggableSquares.add(i);
      }
    }

    // 1, 4, 7
    else if (modulo == 1) {
      for (var i = 1; i < widget.gridPieces; i++) {
        if (i % gridColumnsRows == 1 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      for (int i = blankSquare + 1; i < blankSquare + gridColumnsRows; i++) {
        draggableSquares.add(i);
      }
    }

    // 2, 5, 8
    else if (modulo == 2) {
      for (var i = 1; i < widget.gridPieces; i++) {
        if (i % gridColumnsRows == 2 && i != blankSquare) {
          draggableSquares.add(i);
        }
      }
      draggableSquares.add(blankSquare + 1);
      draggableSquares.add(blankSquare - 1);
    }

    draggableSquares.sort((a, b) => a.compareTo(b));
    if (draggableSquares.contains(widget.initialPieceNumber)) {
      // Sets position of image piece to the blank square
      positionOnGrid = blankSquare;

      // Sets new blank square value
      gameStateData.setBlankSquare(widget.initialPieceNumber);

      return true;
    }

    return false;
  }

  double setNewLeftPosition(double xDistance) {
    double test;
    if (xDistance > 0.0) {
      test = leftPosition + widget.singlePieceWidth;
    } else if (xDistance < 0.0) {
      test = leftPosition - widget.singlePieceWidth;
    }

    return test;
  }

  double setNewTopPosition(double yDistance) {
    double test;
    if (yDistance > 0.0) {
      test = topPosition + widget.singlePieceWidth;
    } else if (yDistance < 0.0) {
      test = topPosition - widget.singlePieceWidth;
    }

    return test;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gridColumnsRows = sqrt(widget.gridPieces).toInt();
    modulo = widget.initialPieceNumber % gridColumnsRows;

    return AnimatedPositioned(
        key: _pieceKey,
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            initial = details.globalPosition.dx;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            xDistance = details.globalPosition.dx - initial;

            if (draggable()) {
              setState(() {
                draggedX = true;
              });
            }
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (draggable()) {
              setState(() {
                leftPosition = setNewLeftPosition(xDistance);
                draggedX = false;
              });
            }
            initial = 0.0;
          },
          onVerticalDragStart: (DragStartDetails details) {
            initial = details.globalPosition.dy;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            yDistance = details.globalPosition.dy - initial;
            if (draggable()) {
              setState(() {
                draggedY = true;
              });
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
            if (draggable()) {
              setState(() {
                topPosition = setNewTopPosition(yDistance);
                draggedY = false;
              });
            }

            initial = 0.0;
          },
          child: Container(
            width: widget.singlePieceWidth,
            height: widget.singlePieceWidth,
            color: Colors.blue,
            child: Center(
                child: Text(
              '${widget.initialPieceNumber}',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
        ),
        left: draggedX ? setNewLeftPosition(xDistance) : leftPosition,
        top: draggedY ? setNewTopPosition(yDistance) : topPosition,
        duration: Duration(milliseconds: 100));
  }
}
