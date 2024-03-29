import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/puzzle_screen/puzzle_card.dart';
import '../components/puzzle_screen/puzzle_screen_hint_button.dart';
import '../components/puzzle_screen/puzzle_screen_quit_button.dart';
import '../components/puzzle_screen/quit_alert.dart';
import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/box_decoration_styes.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({Key key}) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  @override
  void initState() {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.setGridPositions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);

    Future<bool> _quitGameAlert() async {
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
        final bool confirmQuit = await _quitGameAlert();
        return confirmQuit;
      },
      child: Container(
        decoration: kScreenBackgroundBoxDecoration,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // const MuteButton(),
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
            bottomNavigationBar: shopProvider.getBannerAdLoaded
                ? Container(
                    height: 60,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
