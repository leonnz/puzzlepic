import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../styles/customStyles.dart';
import '../components/buttons/puzzle_screen_hint_button.dart';
import '../components/buttons/puzzle_screen_quit_button.dart';
import '../components/buttons/mute_button.dart';
import '../components/puzzle_card.dart';
import '../providers/game_provider.dart';
import '../providers/image_piece_provider.dart';
import '../providers/device_provider.dart';
import '../ad_manager.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    Key key,
  }) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

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

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
    );

    // _loadBannerAd();
    // _loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    // _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    gameProvider.setGridPositions();

    Future<bool> _backPressed() {
      return showDialog(
        context: context,
        builder: (context) => Container(
          width: 500,
          child: AlertDialog(
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
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'No',
                        style: CustomTextTheme(deviceProvider: deviceProvider)
                            .puzzleScreenQuitAlertButtonText(),
                      ),
                      textColor: Color(0xff501E5D),
                    ),
                    FlatButton(
                      onPressed: () {
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
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => ImagePieceProvider(),
      child: WillPopScope(
        onWillPop: () async {
          bool confirmQuit = await _backPressed();
          if (confirmQuit) Navigator.pop(context, true);
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
                      PuzzleScreenHintButton(
                        imageCategory: gameProvider.getImageCategory,
                        imageAssetName: gameProvider.getAssetName,
                      ),
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
