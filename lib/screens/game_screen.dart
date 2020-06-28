import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';
import '../components/button.dart';

import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key key, this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: false);

    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width - 20);

    state.setGameInProgress(true);

    state.setPuzzleImage('$image');

    state.setGridPositions();

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

    Future<bool> _backPressed() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Are you sure you want to quit?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes'),
                  )
                ],
              ));
    }

    quitGame() async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('quit?'),
          content: Text('Are you sure?'),
          actions: [
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      Navigator.pop(context);
    }

    return WillPopScope(
      onWillPop: _backPressed,
      child: Container(
        child: SafeArea(
          child: Scaffold(
            // appBar: AppBar(
            //   title: Text(image),

            // ),

            body: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  child: Text('Title'),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    width: state.getScreenWidth + 5,
                    height: state.getScreenWidth + 5,
                    child: Center(
                      child: Container(
                        width: state.getScreenWidth,
                        height: state.getScreenWidth,
                        color: Colors.red,
                        child: Stack(
                          children: generateImagePieces(),
                        ),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => quitGame(),
                  child: Text('Quit'),
                ),
                Button(
                  buttonText: 'Quit?',
                  action: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
