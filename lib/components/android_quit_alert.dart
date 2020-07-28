import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/device_provider.dart';
import '../styles/customStyles.dart';

class AndroidQuitAlert extends StatelessWidget {
  const AndroidQuitAlert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    return AlertDialog(
      title: Text(
        'Leave this game',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: CustomTextTheme(deviceProvider: deviceProvider)
          .puzzleScreenQuitAlertTitle(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: 40,
            ),
            child: Text(
              'Progress will be lost, are you sure?',
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  deviceProvider.playSound(sound: 'fast_click.wav');
                  Navigator.pop(context, false);
                },
                child: Text(
                  'No',
                  style: CustomTextTheme(deviceProvider: deviceProvider)
                      .puzzleScreenQuitAlertButtonText(),
                ),
                textColor: Color(0xff501E5D),
              ),
              FlatButton(
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
                textColor: Color(0xff501E5D),
              )
            ],
          )
        ],
      ),
      contentTextStyle: CustomTextTheme(deviceProvider: deviceProvider)
          .puzzleScreenQuitAlertContent(),
    );
  }
}
