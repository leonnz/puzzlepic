import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../screens/hint_screen.dart';

class PuzzleScreenHintButton extends StatelessWidget {
  const PuzzleScreenHintButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    Route _customScaleRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HintScreen(
          category: gameProvider.getImageCategory,
          imageAssetname: gameProvider.getAssetName,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.ease),
            child: child,
          );
        },
      );
    }

    return ButtonTheme(
      minWidth: deviceProvider.getUseMobileLayout ? 88 : 150,
      height: deviceProvider.getUseMobileLayout ? 36 : 60,
      buttonColor: Colors.white,
      child: RaisedButton(
        elevation: 3,
        child: Icon(
          Icons.search,
          size: deviceProvider.getUseMobileLayout ? 24 : 40,
        ),
        onPressed: () {
          deviceProvider.playSound(sound: 'play_button_click.wav');
          Navigator.of(context).push(_customScaleRoute());
        },
      ),
    );
  }
}
