import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../components/buttons/puzzle_screen_hint_button.dart';
import '../components/buttons/puzzle_screen_quit_button.dart';
import '../components/buttons/mute_button.dart';
import '../components/puzzle_card/puzzle_card.dart';
import '../components/alerts/quit_alert.dart';
import '../providers/game_provider.dart';
import '../providers/image_piece_provider.dart';
import '../ad_manager.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    Key key,
  }) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad.');
        break;
      case MobileAdEvent.closed:
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home()));
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    // _loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    // _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    gameProvider.setGridPositions();

    quitGameAlert() async {
      bool quit = false;

      if (gameProvider.getPuzzleComplete || gameProvider.getMoves == 0) {
        gameProvider.resetGameState();
        Navigator.pop(context, true);
      } else {
        quit = await showDialog(
          context: context,
          builder: (context) => QuitAlert(),
        );
        if (quit) {
          gameProvider.resetGameState();
          Navigator.pop(context, true);
        }
      }

      return quit;
    }

    return ChangeNotifierProvider(
      create: (_) => ImagePieceProvider(),
      child: WillPopScope(
        onWillPop: () async {
          bool confirmQuit = await quitGameAlert();
          return confirmQuit;
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background.png'),
            ),
          ),
          child: Scaffold(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MuteButton(),
                Spacer(),
                PuzzleCard(
                  interstitialAd: _interstitialAd,
                  isInterstitialAdReady: _isInterstitialAdReady,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      PuzzleScreenHintButton(),
                      PuzzleScreenQuitButton()
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
