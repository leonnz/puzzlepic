import 'package:flutter/material.dart';
import 'package:picturepuzzle/components/image_piece.dart';
import '../components/puzzle_complete_alert.dart';
import '../screens/hint_screen.dart';
import '../providers/game_state_provider.dart';
import '../providers/image_piece_provider.dart';
import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';
import '../data/db_provider.dart';
import '../data/puzzle_record_model.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen(
      {Key key, this.assetName, this.readableName, this.category})
      : super(key: key);

  final String assetName;
  final String readableName;
  final String category;

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

    _loadBannerAd();
    _loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameStateProvider>(context, listen: true);

    state.setGridPositions();

    List<ImagePiece> imagePieceList = <ImagePiece>[];

    Future<bool> _backPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Leave this game'),
          content: Text('Progress will be lost, are you sure?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
              textColor: Color(0xff501E5D),
            ),
            FlatButton(
              onPressed: () {
                state.setPuzzleComplete(false);
                state.resetPiecePositions();
                Navigator.pop(context, true);
              },
              child: Text('Yes'),
              textColor: Color(0xff501E5D),
            )
          ],
        ),
      );
    }

    quitGame() async {
      bool quit = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Leave this game'),
          content: Text('Progress will be lost, are you sure?'),
          actions: [
            FlatButton(
              child: Text("No"),
              textColor: Color(0xff501E5D),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes"),
              textColor: Color(0xff501E5D),
              onPressed: () {
                quit = true;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      if (quit) {
        state.setPuzzleComplete(false);
        state.resetPiecePositions();
        Navigator.pop(context, true);
      }
    }

    Future<dynamic> showPuzzleCompleteAlert() {
      state.setPuzzleComplete(false);

      return showDialog(
        context: context,
        builder: (context) => PuzzleCompleteAlert(
          readableName: widget.readableName,
          fullAd: _interstitialAd,
          fullAdReady: _isInterstitialAdReady,
        ),
      );
    }

    void addPuzzleToRecordDb() {
      DBProviderDb dbProvider = DBProviderDb();
      final record = PuzzleRecord(
        // id: 0,
        puzzleName: widget.readableName,
        puzzleCategory: widget.category,
        complete: 'true',
        bestMoves: 0,
      );

      dbProvider.insertRecord(record);
    }

    List<ImagePiece> generateImagePieces(int numberOfPieces, bool complete) {
      // Always produce 1 less image piece that the grid size
      for (int i = 1; i <= numberOfPieces; i++) {
        imagePieceList.add(
          ImagePiece(
            category: widget.category,
            assetName: widget.assetName,
            pieceNumber: i,
            lastPiece: complete ? true : false,
            puzzleCompleteCallback: showPuzzleCompleteAlert,
          ),
        );
        state.setInitialPuzzlePiecePosition(i);
      }

      if (complete) {
        state.setPuzzleComplete(complete);
        addPuzzleToRecordDb();
      }

      return imagePieceList;
    }

    return ChangeNotifierProvider(
      create: (_) => ImagePieceProvider(),
      child: WillPopScope(
        onWillPop: () async {
          bool confirmQuit = await _backPressed();
          if (confirmQuit) Navigator.pop(context, true);

          return confirmQuit;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Spacer(),
                Text(
                  widget.readableName,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  'Moves: ',
                  // style: Theme.of(context).textTheme.headline3,
                ),
                Card(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Container(
                          width: state.getScreenWidth,
                          height: state.getScreenWidth,
                          color: Colors.grey,
                          child: state.getPuzzleComplete
                              ? Stack(
                                  children: generateImagePieces(16, true),
                                )
                              : Stack(
                                  children: generateImagePieces(15, false),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 3,
                      color: Color(0xff501E5D),
                      child: Text("Hint"),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => HintScreen(
                            category: widget.category,
                            imageAssetname: widget.assetName,
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      elevation: 3,
                      color: Color(0xff501E5D),
                      child: Text("Quit"),
                      onPressed: () => quitGame(),
                    ),
                  ],
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
