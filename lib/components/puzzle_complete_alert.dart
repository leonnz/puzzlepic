import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert(
      {Key key,
      this.readableName,
      this.fullAd,
      this.fullAdReady,
      this.bannerAd})
      : super(key: key);

  final String readableName;
  final InterstitialAd fullAd;
  final bool fullAdReady;
  final BannerAd bannerAd;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Congratulations!')),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('You completed $readableName.'),
            Container(
              margin: EdgeInsets.all(20.0),
              child: FlatButton(
                textColor: Color(0xff501E5D),
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);

                  if (fullAdReady) {
                    fullAd.show();
                    bannerAd.dispose();
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
