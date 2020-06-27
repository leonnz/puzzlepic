import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';

import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key key, this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: false);

    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width);

    state.setGameInProgress(true);

    state.setPuzzleImage('$image');

    List<ImagePiece> generateImagePieces() {
      List<ImagePiece> imagePieceList = <ImagePiece>[];

      // Always produce 1 less image piece that the grid size
      for (int i = 1; i < state.getTotalGridSize; i++) {
        imagePieceList.add(
          ImagePiece(
            pieceNumber: i,
          ),
        );
        state.setInitialPuzzlePiecePosition(i);
      }

      return imagePieceList;
    }

    return Container(
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(image),
            ),
            body: Container(
              width: state.getScreenWidth,
              height: state.getScreenWidth,
              color: Colors.red,
              child: Stack(
                children: generateImagePieces(),
              ),
            )),
      ),
    );
  }
}
