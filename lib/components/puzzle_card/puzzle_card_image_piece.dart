import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_provider.dart';
import '../../providers/image_piece_provider.dart';
import '../../providers/device_provider.dart';
import '../alerts/puzzle_complete_alert.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    this.pieceNumber,
    this.lastPiece,
  }) : super(key: key);

  final int pieceNumber;
  final bool lastPiece;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  Future<dynamic> showPuzzleCompleteAlert() {
    return showDialog(
      context: context,
      builder: (context) => PuzzleCompleteAlert(
          // fullAd: interstitialAd,
          // fullAdReady: isInterstitialAdReady,
          ),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.lastPiece == true) {
        showPuzzleCompleteAlert();
      }
    });
    super.initState();
  }

  @protected
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    ImagePieceProvider imagePieceProvider =
        Provider.of<ImagePieceProvider>(context);
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

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
              if (imagePieceProvider.draggable(
                    pieceNumber: widget.pieceNumber,
                    xDistance: xDistance,
                    yDistance: 0.0,
                    piecePositions: gameProvider.getPiecePositions,
                    blankSquare: gameProvider.getBlankSquare,
                  ) &&
                  !gameProvider.getPuzzleComplete) {
                deviceProvider.playSound(sound: 'image_piece_slide.wav');
                gameProvider.setMoves();
                imagePieceProvider.setPieceLeftPosition(
                  getBlankSquare: gameProvider.getBlankSquare,
                  getPiecePositions: gameProvider.getPiecePositions,
                  getSinglePieceWidth: gameProvider.getSinglePieceWidth,
                  pieceNumber: widget.pieceNumber,
                  setBlankSquare: gameProvider.setBlankSquare,
                  checkComplete: gameProvider.checkComplete,
                  xDistance: xDistance,
                );
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
              if (imagePieceProvider.draggable(
                    pieceNumber: widget.pieceNumber,
                    xDistance: 0.0,
                    yDistance: yDistance,
                    piecePositions: gameProvider.getPiecePositions,
                    blankSquare: gameProvider.getBlankSquare,
                  ) &&
                  !gameProvider.getPuzzleComplete) {
                deviceProvider.playSound(sound: 'image_piece_slide.wav');
                gameProvider.setMoves();
                imagePieceProvider.setPieceTopPosition(
                    getBlankSquare: gameProvider.getBlankSquare,
                    getPiecePositions: gameProvider.getPiecePositions,
                    getSinglePieceWidth: gameProvider.getSinglePieceWidth,
                    pieceNumber: widget.pieceNumber,
                    setBlankSquare: gameProvider.setBlankSquare,
                    checkComplete: gameProvider.checkComplete,
                    yDistance: yDistance);
              }
              dragged = false;
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
            initial = 0.0;
          },
          child: Container(
            decoration: BoxDecoration(
              border: gameProvider.getPuzzleComplete
                  ? null
                  : Border.all(width: 0.7, color: Colors.grey),
            ),
            width: gameProvider.getSinglePieceWidth,
            height: gameProvider.getSinglePieceWidth,
            child: Center(
              child: Image(
                image: AssetImage(
                    'assets/images/${gameProvider.getImageCategory}/${gameProvider.getAssetName}/${gameProvider.getAssetName}_${widget.pieceNumber}.jpg'),
              ),
            ),
          ),
        ),
      ),
      left: imagePieceProvider.getLeftPosition(
          pieceNumber: widget.pieceNumber,
          piecePositions: gameProvider.getPiecePositions),
      top: imagePieceProvider.getTopPosition(
        pieceNumber: widget.pieceNumber,
        piecePositions: gameProvider.getPiecePositions,
      ),
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
