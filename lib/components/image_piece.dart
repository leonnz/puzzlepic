import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/game_provider.dart';
import '../providers/image_piece_provider.dart';

class ImagePiece extends StatefulWidget {
  const ImagePiece({
    Key key,
    this.pieceNumber,
    this.category,
    this.assetName,
    this.lastPiece,
    this.puzzleCompleteAlertCallback,
  }) : super(key: key);

  final String category;
  final String assetName;
  final int pieceNumber;
  final bool lastPiece;
  final Function puzzleCompleteAlertCallback;

  @override
  _ImagePieceState createState() => _ImagePieceState();
}

class _ImagePieceState extends State<ImagePiece>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  AudioCache pieceMoveAudio = AudioCache(prefix: 'audio/');

  @override
  void initState() {
    pieceMoveAudio.load('click.wav');
    pieceMoveAudio.disableLog();

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
        widget.puzzleCompleteAlertCallback();
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
    final state = Provider.of<GameProvider>(context);
    final imagePieceProvider = Provider.of<ImagePieceProvider>(context);

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
                    piecePositions: state.getPiecePositions,
                    blankSquare: state.getBlankSquare,
                    gridSideSize: state.getGridColumns,
                    gridSize: state.getTotalGridSize,
                  ) &&
                  !state.getPuzzleComplete) {
                pieceMoveAudio.play('click.wav',
                    volume: 0.5, mode: PlayerMode.LOW_LATENCY);
                state.setMoves();
                imagePieceProvider.setPieceLeftPosition(
                  getBlankSquare: state.getBlankSquare,
                  getPiecePositions: state.getPiecePositions,
                  getSinglePieceWidth: state.getSinglePieceWidth,
                  pieceNumber: widget.pieceNumber,
                  setBlankSquare: state.setBlankSquare,
                  checkComplete: state.checkComplete,
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
                    piecePositions: state.getPiecePositions,
                    blankSquare: state.getBlankSquare,
                    gridSideSize: state.getGridColumns,
                    gridSize: state.getTotalGridSize,
                  ) &&
                  !state.getPuzzleComplete) {
                pieceMoveAudio.play('click.wav',
                    volume: 0.5, mode: PlayerMode.LOW_LATENCY);
                state.setMoves();
                imagePieceProvider.setPieceTopPosition(
                    getBlankSquare: state.getBlankSquare,
                    getPiecePositions: state.getPiecePositions,
                    getSinglePieceWidth: state.getSinglePieceWidth,
                    pieceNumber: widget.pieceNumber,
                    setBlankSquare: state.setBlankSquare,
                    checkComplete: state.checkComplete,
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
              border: state.getPuzzleComplete
                  ? null
                  : Border.all(width: 0.7, color: Colors.grey),
            ),
            width: state.getSinglePieceWidth,
            height: state.getSinglePieceWidth,
            child: Center(
              child: Image(
                image: AssetImage(
                    'assets/images/${widget.category}/${widget.assetName}/${widget.assetName}_${widget.pieceNumber}.jpg'),
              ),
            ),
          ),
        ),
      ),
      left: imagePieceProvider.getLeftPosition(
          pieceNumber: widget.pieceNumber,
          piecePositions: state.getPiecePositions),
      top: imagePieceProvider.getTopPosition(
        pieceNumber: widget.pieceNumber,
        piecePositions: state.getPiecePositions,
      ),
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
