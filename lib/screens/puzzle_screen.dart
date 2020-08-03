import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/_shared/mute_button.dart';
import '../components/buttons/puzzle_screen_hint_button.dart';
import '../components/puzzle_card/puzzle_card.dart';
import '../components/puzzle_screen/puzzle_screen_quit_button.dart';
import '../components/puzzle_screen/quit_alert.dart';
import '../providers/game_provider.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    Key key,
  }) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    gameProvider.setGridPositions();

    Future<bool> quitGameAlert() async {
      bool quit = false;

      if (gameProvider.getPuzzleComplete || gameProvider.getMoves == 0) {
        gameProvider.resetGameState();
        Navigator.pop(context, true);
      } else {
        quit = await showDialog(
          context: context,
          builder: (BuildContext context) => const QuitAlert(),
        );
        if (quit) {
          gameProvider.resetGameState();
          Navigator.pop(context, true);
        }
      }

      return quit;
    }

    return WillPopScope(
      onWillPop: () async {
        final bool confirmQuit = await quitGameAlert();
        return confirmQuit;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const MuteButton(),
              const Spacer(),
              const PuzzleCard(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[PuzzleScreenHintButton(), PuzzleScreenQuitButton()],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
