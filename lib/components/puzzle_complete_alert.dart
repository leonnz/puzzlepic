import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../providers/game_provider.dart';
import '../styles/customStyles.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({
    Key key,
    this.fullAd,
    this.fullAdReady,
  }) : super(key: key);

  final InterstitialAd fullAd;
  final bool fullAdReady;

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    return AlertDialog(
      title: Text(
        'Congratulations!',
        textAlign: TextAlign.center,
        style: CustomTextTheme(deviceProvider: deviceProvider)
            .puzzleScreenCompleteAlertTitle(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: 40,
            ),
            width: deviceProvider.getUseMobileLayout ? null : 300,
            child: Text(
              'You completed ${gameProvider.getReadableFullname != null ? gameProvider.getReadableFullname : gameProvider.getReadableName} in ${gameProvider.getMoves} moves${gameProvider.getMoves < gameProvider.getBestMoves ? ", a new personal best!" : "."}',
              textAlign: TextAlign.center,
              style: CustomTextTheme(deviceProvider: deviceProvider)
                  .puzzleScreenCompleteAlertContent(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: Color(0xff501E5D),
                child: Text(
                  "Close",
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .puzzleScreenCompleteAlertButtonText(),
                ),
                onPressed: () {
                  Navigator.pop(context, true);

                  if (fullAdReady) {
                    // fullAd.show();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
