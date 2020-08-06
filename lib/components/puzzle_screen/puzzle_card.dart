import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_provider.dart';
import '../../styles/text_theme.dart';
import 'puzzle_card_image_board.dart';
import 'puzzle_card_moves.dart';

class PuzzleCard extends StatelessWidget {
  const PuzzleCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                gameProvider.getImageReadableFullname,
                textAlign: TextAlign.center,
                style: CustomTextTheme.puzzleScreenImageTitle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                gameProvider.getImageTitle,
                style: CustomTextTheme.puzzleScreenPictureSubTitle(),
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
