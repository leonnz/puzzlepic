import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../styles/custom_styles.dart';

class QuitAlert extends StatelessWidget {
  const QuitAlert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    return AlertDialog(
      title: const Text(
        'Leave puzzle',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: CustomTextTheme(deviceProvider: deviceProvider)
          .puzzleScreenQuitAlertTitle(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            width: deviceProvider.getUseMobileLayout ? null : 300,
            child: const Text(
              'Progress will be lost, are you sure?',
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  deviceProvider.playSound(sound: 'fast_click.wav');
                  Navigator.pop(context, false);
                },
                child: Text(
                  'No',
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .puzzleScreenQuitAlertButtonText(),
                ),
              ),
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  deviceProvider.playSound(sound: 'fast_click.wav');
                  gameProvider.resetGameState();
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Yes',
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .puzzleScreenQuitAlertButtonText(),
                ),
              ),
            ],
          ),
        ],
      ),
      contentTextStyle: CustomTextTheme(deviceProvider: deviceProvider)
          .puzzleScreenQuitAlertContent(),
    );
  }
}
