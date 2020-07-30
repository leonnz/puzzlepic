import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../styles/custom_styles.dart';
import 'puzzle_card_image_board.dart';
import 'puzzle_card_moves.dart';

class PuzzleCard extends StatelessWidget {
  const PuzzleCard(
      {Key key,
      @required this.interstitialAd,
      @required this.isInterstitialAdReady})
      : super(key: key);

  final InterstitialAd interstitialAd;
  final bool isInterstitialAdReady;

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    return Container(
      width: gameProvider.getScreenWidth + 20,
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                gameProvider.getReadableFullname,
                textAlign: TextAlign.center,
                style: CustomTextTheme(deviceProvider: deviceProvider)
                    .puzzleScreenImageTitle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                gameProvider.getTitle,
                style: CustomTextTheme(deviceProvider: deviceProvider)
                    .puzzleScreenPictureSubTitle(),
              ),
            ),
            const PuzzleCardMoves(),
            PuzzleCardImageBoard(
              interstitialAd: interstitialAd,
              isInterstitialAdReady: isInterstitialAdReady,
            ),
          ],
        ),
      ),
    );
  }
}
