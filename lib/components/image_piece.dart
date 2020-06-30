import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({Key key, this.pieceNumber, this.imageName, this.lastPiece})
      : super(key: key);

  final String imageName;
  final int pieceNumber;
  final bool lastPiece;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: true);

    bool dragged = false;
    double initial = 0.0;
    double xDistance = 0.0;
    double yDistance = 0.0;

    _controller.forward();

    return AnimatedPositioned(
      child: FadeTransition(
        opacity: widget.lastPiece
            ? _animation
            : Tween(begin: 1.0, end: 1.0).animate(_controller),
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            initial = details.globalPosition.dx;
            dragged = true;
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            xDistance = details.globalPosition.dx - initial;
            if (dragged) {
              if (state.draggable(
                  pieceNumber: widget.pieceNumber,
                  xDistance: xDistance,
                  yDistance: 0.0)) {
                state.setPieceLeftPosition(widget.pieceNumber, xDistance);
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
                  pieceNumber: widget.pieceNumber,
                  xDistance: 0.0,
                  yDistance: yDistance)) {
                state.setPieceTopPosition(widget.pieceNumber, yDistance);
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
                child: Image(
              image: AssetImage(
                  'assets/images/animals/${widget.imageName}/${widget.imageName}_${widget.pieceNumber}.png'),
            )),
          ),
        ),
      ),
      left: state.getLeftPosition(widget.pieceNumber),
      top: state.getTopPosition(widget.pieceNumber),
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
