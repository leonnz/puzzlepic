import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/device_provider.dart';
import '../screens/hint_screen.dart';

class PuzzleScreenHintButton extends StatelessWidget {
  const PuzzleScreenHintButton(
      {Key key, this.imageCategory, this.imageAssetName})
      : super(key: key);

  final String imageCategory;
  final String imageAssetName;

  Route _customScaleRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HintScreen(
        category: imageCategory,
        imageAssetname: imageAssetName,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.ease),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

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
          deviceProvider.getAudioCache.play(
            'play_button_click.wav',
            mode: PlayerMode.LOW_LATENCY,
          );
          Navigator.of(context).push(_customScaleRoute());
        },
      ),
    );
  }
}
