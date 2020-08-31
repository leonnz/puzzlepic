import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/image_piece_provider.dart';
import '../puzzle_screen/puzzle_complete_alert.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    @required this.pieceNumber,
    @required this.lastPiece,
    @required this.interstitialAd,
    @required this.isInterstitialAdReady,
  }) : super(key: key);

  final int pieceNumber;
  final bool lastPiece;
  final InterstitialAd interstitialAd;
  final bool isInterstitialAdReady;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  Future<bool> _showPuzzleCompleteAlert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => PuzzleCompleteAlert(
        fullAd: widget.interstitialAd,
        fullAdReady: widget.isInterstitialAdReady,
      ),
    );
  }

  @override
  void initState() {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.addStatusListener((AnimationStatus status) async {
      if (status == AnimationStatus.completed && widget.lastPiece == true) {
        await gameProvider.puzzleCompleteDb();
        _showPuzzleCompleteAlert();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    bool dragged = false;
    double initial = 0.0;
    double xDistance = 0.0;
    double yDistance = 0.0;

    _controller.forward();
    return ChangeNotifierProvider<ImagePieceProvider>(
      create: (BuildContext context) => ImagePieceProvider(),
      child: Consumer<ImagePieceProvider>(
        builder: (BuildContext context, ImagePieceProvider image, Widget child) {
          return AnimatedPositioned(
            left: image.getLeftPosition(
                pieceNumber: widget.pieceNumber, piecePositions: gameProvider.getPiecePositions),
            top: image.getTopPosition(
              pieceNumber: widget.pieceNumber,
              piecePositions: gameProvider.getPiecePositions,
            ),
            duration: const Duration(milliseconds: 100),
            child: FadeTransition(
              opacity: widget.lastPiece
                  ? _animation
                  : Tween<double>(begin: 1.0, end: 1.0).animate(_controller),
              child: GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  initial = details.globalPosition.dx;
                  dragged = true;
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  xDistance = details.globalPosition.dx - initial;
                  if (dragged) {
                    if (image.draggable(
                          pieceNumber: widget.pieceNumber,
                          xDistance: xDistance,
                          yDistance: 0.0,
                          piecePositions: gameProvider.getPiecePositions,
                          blankSquare: gameProvider.getBlankSquare,
                        ) &&
                        !gameProvider.getPuzzleComplete) {
                      deviceProvider.playSound(sound: 'image_piece_slide.wav');
                      gameProvider.setMoves();
                      image.setPieceLeftPosition(
                        getBlankSquare: gameProvider.getBlankSquare,
                        getPiecePositions: gameProvider.getPiecePositions,
                        getSinglePieceWidth: gameProvider.getSinglePieceWidth,
                        pieceNumber: widget.pieceNumber,
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
                    if (image.draggable(
                          pieceNumber: widget.pieceNumber,
                          xDistance: 0.0,
                          yDistance: yDistance,
                          piecePositions: gameProvider.getPiecePositions,
                          blankSquare: gameProvider.getBlankSquare,
                        ) &&
                        !gameProvider.getPuzzleComplete) {
                      deviceProvider.playSound(sound: 'image_piece_slide.wav');
                      gameProvider.setMoves();
                      image.setPieceTopPosition(
                          getBlankSquare: gameProvider.getBlankSquare,
                          getPiecePositions: gameProvider.getPiecePositions,
                          getSinglePieceWidth: gameProvider.getSinglePieceWidth,
                          pieceNumber: widget.pieceNumber,
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
                          'assets/images/${gameProvider.getImageCategoryAssetName}/${gameProvider.getImageAssetName}/${gameProvider.getImageAssetName}_${widget.pieceNumber}.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
