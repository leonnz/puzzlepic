import 'package:PuzzlePic/providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_provider.dart';
import '../../styles/text_styles.dart';
import 'puzzle_card_image_board.dart';
import 'puzzle_card_moves.dart';

class PuzzleCard extends StatelessWidget {
  const PuzzleCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return Container(
      width: gameProvider.getScreenWidth + 20,
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: deviceProvider.getUseMobileLayout ? 10 : 20,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: Text(
                gameProvider.getImageReadableFullname,
                textAlign: TextAlign.center,
                style: kPuzzleScreenImageTitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Text(
                gameProvider.getImageTitle,
                textAlign: TextAlign.center,
                style: kPuzzleScreenPictureSubTitle,
              ),
            ),
            const PuzzleCardMoves(),
            const PuzzleCardImageBoard(),
          ],
        ),
      ),
    );
  }
}
