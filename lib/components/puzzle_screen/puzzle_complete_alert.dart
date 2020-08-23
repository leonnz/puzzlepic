import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../styles/text_theme.dart';

class PuzzleCompleteAlert extends StatelessWidget {
  const PuzzleCompleteAlert({
    Key key,
    @required this.fullAd,
    @required this.fullAdReady,
  }) : super(key: key);

  final InterstitialAd fullAd;
  final bool fullAdReady;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return AlertDialog(
      title: Text(
        'Congratulations!',
        textAlign: TextAlign.center,
        style: CustomTextTheme.puzzleScreenCompleteAlertTitle(),
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
              'You completed ${gameProvider.getImageReadableFullname ?? gameProvider.getImageReadableName} in ${gameProvider.getMoves} moves${gameProvider.getMoves < gameProvider.getBestMoves ? ", a new personal best!" : "."}',
              textAlign: TextAlign.center,
              style: CustomTextTheme.puzzleScreenCompleteAlertContent(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  Navigator.pop(context, true);
                  if (fullAdReady) {
                    fullAd.show();
                  }
                },
                child: Text(
                  'Close',
                  style: CustomTextTheme.puzzleScreenCompleteAlertButtonText(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
