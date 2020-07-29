import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../styles/customStyles.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({
    Key key,
    // this.fullAd,
    // this.fullAdReady,
  }) : super(key: key);

  // final InterstitialAd fullAd;
  // final bool fullAdReady;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return ChangeNotifierProvider<GameProvider>(
      create: (BuildContext context) => GameProvider(),
      child: AlertDialog(
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
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              width: deviceProvider.getUseMobileLayout ? null : 300,
              child: Text(
                'You completed ${gameProvider.getReadableFullname ?? gameProvider.getReadableName} in ${gameProvider.getMoves} moves${gameProvider.getMoves < gameProvider.getBestMoves ? ", a new personal best!" : "."}',
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
                  textColor: const Color(0xff501E5D),
                  onPressed: () {
                    Navigator.pop(context, true);

                    // if (fullAdReady) {
                    //   // fullAd.show();
                    // }
                  },
                  child: Text(
                    'Close',
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .puzzleScreenCompleteAlertButtonText(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
