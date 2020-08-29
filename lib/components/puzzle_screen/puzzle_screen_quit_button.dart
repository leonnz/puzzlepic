import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../puzzle_screen/quit_alert.dart';

class PuzzleScreenQuitButton extends StatelessWidget {
  const PuzzleScreenQuitButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of(context, listen: false);

    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    Future<void> _quitGameAlert() async {
      bool quit = false;
      quit = await showDialog(
        context: context,
        builder: (BuildContext context) => const QuitAlert(),
      );
      if (quit) {
        gameProvider.resetGameState();
        Navigator.pop(context, true);
      }
    }

    return ButtonTheme(
      minWidth: DeviceProvider.shortestSide / 4.8,
      height: DeviceProvider.shortestSide / 12,
      buttonColor: Colors.white,
      child: RaisedButton(
        elevation: 3,
        onPressed: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
          if (gameProvider.getPuzzleComplete || gameProvider.getMoves == 0) {
            gameProvider.resetGameState();
            Navigator.pop(context, true);
          } else {
            _quitGameAlert();
          }
        },
        child: Icon(
          Icons.close,
          size: DeviceProvider.shortestSide / 18,
        ),
      ),
    );
  }
}
