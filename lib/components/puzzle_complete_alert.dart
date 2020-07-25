import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({
    Key key,
    this.readableName,
    this.readableFullname,
    this.fullAd,
    this.fullAdReady,
    this.moves,
    this.bestMoves,
  }) : super(key: key);

  final String readableName;
  final String readableFullname;
  final InterstitialAd fullAd;
  final bool fullAdReady;
  final int moves;
  final int bestMoves;

  @override
  Widget build(BuildContext context) {
    print(bestMoves);
    return AlertDialog(
      title: Text(
        'Congratulations!',
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'You completed ${readableFullname != null ? readableFullname : readableName} in $moves moves${moves < bestMoves ? ", a new personal best!" : "."}',
              textAlign: TextAlign.center,
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: FlatButton(
                textColor: Color(0xff501E5D),
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context, true);

                  if (fullAdReady) {
                    // fullAd.show();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
