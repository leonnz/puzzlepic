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
    final screenWidth = MediaQuery.of(context).size.width;
    final int totalGridPieces = 9;
    final double singlePieceWidth = screenWidth / sqrt(totalGridPieces);
    double blankPiecePosition = double.parse(
        (singlePieceWidth * (sqrt(totalGridPieces) - 1)).toStringAsFixed(1));

    List<Widget> imagePieceList = <Widget>[];

    int blankSquare = totalGridPieces;

    offsetCallback(int pieceNumber, Offset offset) {
      positions.add({
        "piece": pieceNumber,
        "offset": offset,
        "empty": false,
      });
      positions.sort((a, b) => a.keys.first.compareTo(b.keys.first));
      // print(positions);
    }

    List<Widget> generateImagePieces({int numberOfImagePieces}) {
      // Always produce 1 less image piece that the grid size
      for (int i = 1; i < numberOfImagePieces; i++) {
        imagePieceList.add(
          ImagePiece(
            pieceNumber: i,
            gridPieces: totalGridPieces,
            offsetCallback: offsetCallback,
          ),
        );
      }
      positions.add({
        "pieces": totalGridPieces,
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
              width: screenWidth,
              height: screenWidth,
              color: Colors.red,
              child: ChangeNotifierProvider(
                create: (context) => GameStateProvider(),
                child: Stack(
                  children:
                      generateImagePieces(numberOfImagePieces: totalGridPieces),
                ),
              ),
            )),
      ),
    );
  }
}
