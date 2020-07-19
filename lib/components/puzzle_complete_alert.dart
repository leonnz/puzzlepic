import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({
    Key key,
    this.readableName,
    this.readableFullname,
    this.fullAd,
    this.fullAdReady,
  }) : super(key: key);

  final String readableName;
  final String readableFullname;
  final InterstitialAd fullAd;
  final bool fullAdReady;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Congratulations!')),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                'You completed ${readableFullname != null ? readableFullname : readableName}.'),
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
