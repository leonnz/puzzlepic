import 'dart:math';

import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';

import '../providers/gameStateProvider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, @required this.image}) : super(key: key);

  final String image;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Map<String, dynamic>> positions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameStateData =
        Provider.of<GameStateProvider>(context, listen: false);

    gameStateData.setScreenWidth(
        screenwidth: MediaQuery.of(context).size.width);

    gameStateData.setGameInProgress(true);

    gameStateData.setPuzzleImage('${widget.image}');

    List<Widget> imagePieceList = <Widget>[];

    offsetCallback(int pieceNumber, Offset offset) {
      positions.add({
        "piece": pieceNumber,
        "offset": offset,
        "empty": false,
      });
      positions.sort((a, b) => a.keys.first.compareTo(b.keys.first));
    }

    List<Widget> generateImagePieces() {
      if (gameStateData.getGameInProgress &&
          gameStateData.getPuzzleImage == widget.image) {}
      // Always produce 1 less image piece that the grid size
      for (int i = 1; i < gameStateData.getTotalGridSize; i++) {
        imagePieceList.add(
          ImagePiece(
            initialPieceNumber: i,
            gridPieces: gameStateData.getTotalGridSize,
            gridSideSize: gameStateData.getGridSideSize,
            singlePieceWidth: gameStateData.getSinglePieceWidth,
            offsetCallback: offsetCallback,
          ),
        );
      }

      double blankPiecePosition = double.parse(
          (gameStateData.getSinglePieceWidth *
                  (sqrt(gameStateData.getTotalGridSize) - 1))
              .toStringAsFixed(1));

      positions.add({
        "piece": gameStateData.getTotalGridSize,
        "offset": Offset(blankPiecePosition, blankPiecePosition),
        "empty": true,
      });
      return imagePieceList;
    }

    return Container(
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.image),
            ),
            body: Container(
              width: gameStateData.getScreenWidth,
              height: gameStateData.getScreenWidth,
              color: Colors.red,
              child: Stack(
                children: generateImagePieces(),
              ),
            )),
      ),
    );
  }
}
