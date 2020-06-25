import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gameStateProvider.dart';

class ImagePiece extends StatelessWidget {
  const ImagePiece({Key key, this.pieceNumber}) : super(key: key);

  final int pieceNumber;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: true);

    bool dragged = false;
    double initial = 0.0;
    double xDistance = 0.0;
    double yDistance = 0.0;

    return AnimatedPositioned(
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            initial = details.globalPosition.dx;
            dragged = true;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            xDistance = details.globalPosition.dx - initial;
            if (dragged) {
              if (state.draggable(
                  pieceNumber: pieceNumber,
                  xDistance: xDistance,
                  yDistance: 0.0)) {
                state.setPieceLeftPosition(pieceNumber, xDistance);
              }
              dragged = false;
            }
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            initial = 0.0;
          },
          onVerticalDragStart: (DragStartDetails details) {
            initial = details.globalPosition.dy;
            dragged = true;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            yDistance = details.globalPosition.dy - initial;
            if (dragged) {
              if (state.draggable(
                  pieceNumber: pieceNumber,
                  xDistance: 0.0,
                  yDistance: yDistance)) {
                state.setPieceTopPosition(pieceNumber, yDistance);
              }
              dragged = false;
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
            initial = 0.0;
          },
          child: Container(
            width: state.getSinglePieceWidth,
            height: state.getSinglePieceWidth,
            color: Colors.blue,
            child: Center(
                child: Text(
              '$pieceNumber',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
        ),
        left: state.getLeftPosition(pieceNumber),
        top: state.getTopPosition(pieceNumber),
        duration: Duration(milliseconds: 100));
  }
}
