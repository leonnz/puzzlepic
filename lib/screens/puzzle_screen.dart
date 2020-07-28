import 'package:flutter/material.dart';
import 'package:PuzzlePic/components/image_piece.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../data/db_provider.dart';
import '../data/puzzle_record_model.dart';
import '../styles/customStyles.dart';
import '../components/puzzle_complete_alert.dart';
import '../components/puzzle_screen_hint_button.dart';
import '../components/puzzle_screen_quit_button.dart';
import '../providers/game_provider.dart';
import '../providers/image_piece_provider.dart';
import '../providers/device_provider.dart';
import '../ad_manager.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen(
      {Key key,
      this.imageAssetName,
      this.imageReadableName,
      this.imageReadableFullname,
      this.imageTitle,
      this.imageCategory})
      : super(key: key);

  final String imageAssetName;
  final String imageReadableName;
  final String imageReadableFullname;
  final String imageTitle;
  final String imageCategory;

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

    DBProviderDb dbProvider = DBProviderDb();

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

    Future<dynamic> showPuzzleCompleteAlert() {
      return showDialog(
        context: context,
        builder: (context) => PuzzleCompleteAlert(
          readableName: widget.imageReadableName,
          readableFullname: widget.imageReadableFullname,
          fullAd: _interstitialAd,
          fullAdReady: _isInterstitialAdReady,
          moves: gameProvider.getMoves,
          bestMoves: gameProvider.getBestMoves,
        ),
      ).then((value) {
        if (value) {
          setState(() {});
        }
      });
    }

    void puzzleCompleteDb() async {
      gameProvider.setPuzzleComplete(true);

      DBProviderDb dbProvider = DBProviderDb();

      List<String> currentRecords = await dbProvider.getRecords();

      if (currentRecords.contains(widget.imageReadableName)) {
        List<Map<String, dynamic>> existingRecord = await dbProvider
            .getSingleRecord(puzzleName: widget.imageReadableName);

        int existingRecordBestMoves = existingRecord[0]['bestMoves'];

        if (gameProvider.getMoves < existingRecordBestMoves) {
          // Sets the best moves to the previous best moves, so the complete puzzle alert can calculate if it is a new best.
          gameProvider.setBestMoves(moves: existingRecordBestMoves);
          dbProvider.updateRecord(
              moves: gameProvider.getMoves,
              puzzleName: widget.imageReadableName);
          setState(() {});
        }
      } else {
        gameProvider.setBestMoves(moves: gameProvider.getMoves);
        final record = PuzzleRecord(
          puzzleName: widget.imageReadableName,
          puzzleCategory: widget.imageCategory,
          complete: 'true',
          moves: gameProvider.getMoves,
        );

        dbProvider.insertRecord(record: record);
        setState(() {});
      }
    }

    List<ImagePiece> generateImagePieces(int numberOfPieces, bool complete) {
      List<ImagePiece> imagePieceList = <ImagePiece>[];
      // Always produce 1 less image piece that the grid size
      for (int i = 1; i <= numberOfPieces; i++) {
        imagePieceList.add(
          ImagePiece(
            category: widget.imageCategory,
            assetName: widget.imageAssetName,
            pieceNumber: i,
            lastPiece: complete ? true : false,
            puzzleCompleteAlertCallback: showPuzzleCompleteAlert,
          ),
        );
        gameProvider.setInitialPuzzlePiecePosition(i);
      }

      if (complete) {
        gameProvider.setPuzzleComplete(complete);
        puzzleCompleteDb();
      }

      return imagePieceList;
    }

    getSingleRecord() async {
      int best = 0;
      List<Map<String, dynamic>> record = await dbProvider.getSingleRecord(
          puzzleName: widget.imageReadableName);

      if (record.length > 0) {
        best = record[0]['bestMoves'];
      }
      return best;
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
                GestureDetector(
                  onTap: () {
                    deviceProvider.setMuteSounds();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              )
                            ]),
                        child: Icon(
                          deviceProvider.getMuteSounds
                              ? Icons.volume_off
                              : Icons.volume_mute,
                          size: 50,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: gameProvider.getScreenWidth + 20,
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.imageReadableFullname != null
                                ? widget.imageReadableFullname
                                : widget.imageReadableName,
                            textAlign: TextAlign.center,
                            style:
                                CustomTextTheme(deviceProvider: deviceProvider)
                                    .puzzleScreenImageTitle(),
                          ),
                        ),
                        widget.imageTitle != null
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  widget.imageTitle,
                                  style: CustomTextTheme(
                                          deviceProvider: deviceProvider)
                                      .puzzleScreenPictureSubTitle(),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Moves: ${gameProvider.getMoves}',
                                style: CustomTextTheme(
                                        deviceProvider: deviceProvider)
                                    .puzzleScreenMovesCounter(),
                              ),
                              FutureBuilder(
                                future: getSingleRecord(),
                                initialData: 0,
                                builder:
                                    (context, AsyncSnapshot<int> snapshot) {
                                  Widget bestMoves;

                                  if (snapshot.hasData) {
                                    int moves = snapshot.data;
                                    bestMoves = Text(
                                      'Best moves: $moves',
                                      style: CustomTextTheme(
                                              deviceProvider: deviceProvider)
                                          .puzzleScreenMovesCounter(),
                                    );
                                  } else {
                                    bestMoves = Text(
                                      'Best moves: 0',
                                      style: CustomTextTheme(
                                              deviceProvider: deviceProvider)
                                          .puzzleScreenMovesCounter(),
                                    );
                                  }
                                  return bestMoves;
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: gameProvider.getScreenWidth,
                            height: gameProvider.getScreenWidth,
                            color: Colors.grey,
                            child: gameProvider.getPuzzleComplete
                                ? Stack(
                                    children: generateImagePieces(
                                        gameProvider.getTotalGridSize, true),
                                  )
                                : Stack(
                                    children: generateImagePieces(
                                        gameProvider.getTotalGridSize - 1,
                                        false),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      PuzzleScreenHintButton(
                        imageCategory: widget.imageCategory,
                        imageAssetName: widget.imageAssetName,
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
