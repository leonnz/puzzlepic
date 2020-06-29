import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';
import '../components/button.dart';

import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key key, this.image}) : super(key: key);

  final String image;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context);
    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width - 20);
    state.setGameInProgress(true);
    state.setPuzzleImage('$image');
    state.setImageName('$image');
    state.setGridPositions();

    List<ImagePiece> generateImagePieces() {
      List<ImagePiece> imagePieceList = <ImagePiece>[];

      // Always produce 1 less image piece that the grid size
      for (int i = 1; i < state.getTotalGridSize; i++) {
        imagePieceList.add(
          ImagePiece(
            imageName: state.getImageName,
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
      bool quit = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Leave this game'),
          content: Text('Progress will be lost, are you sure?'),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                quit = true;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      if (quit) {
        Navigator.pop(context);
      }
    }

    // Shows the full image.
    showHint() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text(capitalize(state.getImageName))),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(image),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: _backPressed,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: Text(
                  capitalize(state.getImageName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
              Button(
                buttonText: 'Hint',
                margin: 40.0,
                action: () => showHint(),
              ),
              Button(
                buttonText: 'Quit',
                margin: 20.0,
                action: () => quitGame(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
