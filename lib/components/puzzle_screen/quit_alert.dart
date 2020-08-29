import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/device_provider.dart';
import '../../styles/text_styles.dart';

class QuitAlert extends StatelessWidget {
  const QuitAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    return AlertDialog(
      title: const Text(
        'Leave puzzle',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: kPuzzleScreenQuitAlertTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              bottom: 40,
            ),
            width: DeviceProvider.shortestSide / 2.3,
            child: const Text(
              'Progress will be lost, are you sure?',
              textAlign: TextAlign.center,
            ),
          ),
          Row(
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
                  style: kPuzzleScreenQuitAlertButtonText,
                ),
              ),
              FlatButton(
                textColor: const Color(0xff501E5D),
                onPressed: () {
                  deviceProvider.playSound(sound: 'fast_click.wav');
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Yes',
                  style: kPuzzleScreenQuitAlertButtonText,
                ),
              ),
            ],
          ),
        ],
      ),
      contentTextStyle: kPuzzleScreenQuitAlertContent,
    );
  }
}
