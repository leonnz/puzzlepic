import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../providers/game_provider.dart';
import '../styles/customStyles.dart';

class PuzzleScreenQuitButton extends StatelessWidget {
  const PuzzleScreenQuitButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: false);

    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    quitGameAlert() async {
      bool quit = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                width: deviceProvider.getUseMobileLayout ? null : 300,
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
                    child: Text(
                      "No",
                      style: CustomTextTheme(deviceProvider: deviceProvider)
                          .puzzleScreenQuitAlertButtonText(),
                    ),
                    textColor: Color(0xff501E5D),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text(
                      "Yes",
                      style: CustomTextTheme(deviceProvider: deviceProvider)
                          .puzzleScreenQuitAlertButtonText(),
                    ),
                    textColor: Color(0xff501E5D),
                    onPressed: () {
                      quit = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          contentTextStyle: CustomTextTheme(deviceProvider: deviceProvider)
              .puzzleScreenQuitAlertContent(),
        ),
      );
      if (quit) {
        gameProvider.resetGameState();
        Navigator.pop(context, true);
      }
    }

    return ButtonTheme(
      minWidth: deviceProvider.getUseMobileLayout ? 88 : 150,
      height: deviceProvider.getUseMobileLayout ? 36 : 60,
      buttonColor: Colors.white,
      child: RaisedButton(
          elevation: 3,
          child: Icon(
            Icons.close,
            size: deviceProvider.getUseMobileLayout ? 24 : 40,
          ),
          onPressed: () {
            if (gameProvider.getPuzzleComplete) {
              gameProvider.resetGameState();
              Navigator.pop(context, true);
            } else {
              quitGameAlert();
            }
          }),
    );
  }
}
