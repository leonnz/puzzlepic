import 'dart:math';

import 'package:flutter/material.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    this.image,
    this.pieceNumber,
    this.gridPieces,
    this.offsetCallback,
    // this.leftPosition,
  }) : super(key: key);

  final String image;
  final int pieceNumber;
  final int gridPieces;
  final Function(int, Offset) offsetCallback;

  // final double leftPosition;
  // final double topPosition;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  final GlobalKey _pieceKey = GlobalKey();
  double distance = 0.0;
  double initial = 0.0;
  bool clicked = false;

  double screenWidth;
  double singlePieceWidth;
  int gridColumnsRows;
  int modulo;

  double leftPosition;
  double topPosition;

  @override
  void initState() {
    super.initState();
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
    bool draggable;

    return draggable;
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
            initial = details.globalPosition.dx;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            distance = details.globalPosition.dx - initial;
            if (distance > 0.0 && draggable()) {
              setState(() {
                clicked = true;
              });
            }
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            initial = 0.0;
          },
          child: Container(
            width: singlePieceWidth,
            height: singlePieceWidth,
            color: Colors.blue,
          ),
        ),
        left: clicked ? singlePieceWidth : calculateLeftPosition(),
        top: calculateTopPosition(),
        duration: Duration(milliseconds: 100));
  }
}
