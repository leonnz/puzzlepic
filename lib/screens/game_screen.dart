import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';
import '../components/button.dart';
import '../providers/game_state_provider.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key key, this.assetName, this.readableName, this.category})
      : super(key: key);

  final String assetName;
  final String readableName;
  final String category;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: true);
    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width - 20);

    state.setGridPositions();

    List<ImagePiece> imagePieceList = <ImagePiece>[];

    List<ImagePiece> generateImagePieces(int numberOfPieces, bool complete) {
      // Always produce 1 less image piece that the grid size
      for (int i = 1; i <= numberOfPieces; i++) {
        imagePieceList.add(
          ImagePiece(
            category: category,
            assetName: assetName,
            pieceNumber: i,
            lastPiece: complete ? true : false,
          ),
        );
        state.setInitialPuzzlePiecePosition(i);
        state.setPuzzleComplete(false);
      }

      return imagePieceList;
    }

    Future<bool> _backPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Leave this game'),
          content: Text('Progress will be lost, are you sure?'),
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
        ),
      );
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
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/$category/$assetName.png'),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 100,
                child: Text(
                  readableName,
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
                      child: state.getPuzzleComplete
                          ? Stack(
                              children: generateImagePieces(16, true),
                            )
                          : Stack(
                              children: generateImagePieces(15, false),
                            ),
                    ),
                  ),
                ),
              ),
              Button(
                buttonText: 'Hint',
                action: () => showHint(),
              ),
              Button(
                buttonText: 'Quit',
                action: () => quitGame(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
