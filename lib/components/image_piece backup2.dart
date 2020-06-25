import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gameStateProvider.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    this.image,
    this.pieceNumber,
    this.gridPieces,
    this.offsetCallback,
  }) : super(key: key);

  final String image;
  final int pieceNumber;
  final int gridPieces;
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
  bool dragged = false;
  bool draggedX = false;
  bool draggedY = false;

  double screenWidth;
  double singlePieceWidth;
  int gridColumnsRows;
  int modulo;

  double leftPosition;
  double topPosition;

  @override
  void initState() {
    super.initState();
    // TODO init the left and top position values here

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getPosition(widget.pieceNumber));
  }

  getPosition(int p) {
    RenderBox _piece1Box = _pieceKey.currentContext.findRenderObject();
    Offset position = _piece1Box.localToGlobal(Offset.zero);
    // print('$position, $p');
    widget.offsetCallback(
        widget.pieceNumber, Offset(leftPosition, topPosition));
  }

  double calculateLeftPosition() {
    if (modulo == 0) {
      leftPosition = singlePieceWidth * (gridColumnsRows - 1);
    } else if (modulo == 1) {
      leftPosition = 0;
    } else if (modulo == 2) {
      leftPosition = singlePieceWidth;
    } else if (modulo == 3) {
      leftPosition = singlePieceWidth * 2;
    } else if (modulo == 4) {
      leftPosition = singlePieceWidth * 3;
    }
    return leftPosition;
  }

  double calculateTopPosition() {
    if (widget.pieceNumber <= gridColumnsRows) {
      topPosition = 0;
    } else if (widget.pieceNumber > gridColumnsRows &&
        widget.pieceNumber <= (gridColumnsRows * 2)) {
      topPosition = singlePieceWidth;
    } else if (widget.pieceNumber > (gridColumnsRows * 2) &&
        widget.pieceNumber <= (gridColumnsRows * 3)) {
      topPosition = singlePieceWidth * 2;
    } else if (widget.pieceNumber > (gridColumnsRows * 3) &&
        widget.pieceNumber <= (gridColumnsRows * 4)) {
      topPosition = singlePieceWidth * 3;
    } else {
      topPosition = singlePieceWidth * 4;
    }

    return topPosition;
  }

  bool draggable() {
    List<int> draggableSquares = [];
    final gameStateData =
        Provider.of<GameStateProvider>(context, listen: false);
    final blankSquare = gameStateData.blankSquare;

    // print(blankSquare);

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
    // print(draggableSquares);

    if (draggableSquares.contains(widget.pieceNumber)) {
      return true;
    }

    return false;
  }

  double setXAxisDragDirection(double xDistance) {
    double test;
    if (xDistance > 0.0) {
      test = leftPosition + singlePieceWidth;
    } else if (xDistance < 0.0) {
      test = leftPosition - singlePieceWidth;
    }
    print(test);
    return test;
  }

  double setYAxisDragDirection(double yDistance) {
    double test;
    if (yDistance > 0.0) {
      test = topPosition + singlePieceWidth;
    } else if (yDistance < 0.0) {
      test = topPosition - singlePieceWidth;
    }

    return test;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    gridColumnsRows = sqrt(widget.gridPieces).toInt();
    singlePieceWidth = screenWidth / gridColumnsRows;
    modulo = widget.pieceNumber % gridColumnsRows;

    return AnimatedPositioned(
        key: _pieceKey,
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            setState(() {
              draggedX = false;
            });
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
            if (draggedX) {
              if (xDistance > 0.0) {
                leftPosition += singlePieceWidth;
              } else if (xDistance < 0.0) {
                leftPosition -= singlePieceWidth;
              }

              Provider.of<GameStateProvider>(context, listen: false)
                  .setBlankSquare(widget.pieceNumber);
            }
            initial = 0.0;
          },
          onVerticalDragStart: (DragStartDetails details) {
            setState(() {
              draggedY = false;
            });
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
            if (draggedY) {
              if (yDistance > 0.0) {
                topPosition += singlePieceWidth;
              } else if (yDistance < 0.0) {
                topPosition -= singlePieceWidth;
              }

              Provider.of<GameStateProvider>(context, listen: false)
                  .setBlankSquare(widget.pieceNumber);
            }

            initial = 0.0;
          },
          child: Container(
            width: singlePieceWidth,
            height: singlePieceWidth,
            color: Colors.blue,
          ),
        ),
        left: draggedX
            ? setXAxisDragDirection(xDistance)
            : calculateLeftPosition(), //hmmm
        top: draggedY
            ? setYAxisDragDirection(yDistance)
            : calculateTopPosition(), //hmmm
        duration: Duration(milliseconds: 100));
  }
}
