import 'package:flutter/material.dart';
import 'package:PuzzlePic/components/image_piece.dart';
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

  Route _customScaleRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HintScreen(
        category: widget.category,
        imageAssetname: widget.assetName,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.ease),
          child: child,
        );
      },
    );
  }

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

    DBProviderDb dbProvider = DBProviderDb();

    void resetGameState() {
      state.setPuzzleComplete(false);
      state.resetPiecePositions();
      state.resetMoves();
    }

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
                resetGameState();
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
        resetGameState();
        Navigator.pop(context, true);
      }
    }

    Future<dynamic> showPuzzleCompleteAlert() {
      return showDialog(
        context: context,
        builder: (context) => PuzzleCompleteAlert(
          readableName: widget.readableName,
          fullAd: _interstitialAd,
          fullAdReady: _isInterstitialAdReady,
        ),
      ).then((value) {
        if (value) {
          // setState(() {});
        }
      });
    }

    void puzzleCompleteDb() async {
      state.setPuzzleComplete(true);

      DBProviderDb dbProvider = DBProviderDb();

      List<String> currentRecords = await dbProvider.getRecords();

      if (currentRecords.contains(widget.readableName)) {
        List<Map<String, dynamic>> existingRecord =
            await dbProvider.getSingleRecord(puzzleName: widget.readableName);

        int existingRecordBestMoves = existingRecord[0]['bestMoves'];

        if (state.getMoves < existingRecordBestMoves) {
          dbProvider.updateRecord(
              moves: state.getMoves, puzzleName: widget.readableName);
          setState(() {});
        }
      } else {
        final record = PuzzleRecord(
          puzzleName: widget.readableName,
          puzzleCategory: widget.category,
          complete: 'true',
          moves: state.getMoves,
        );

        dbProvider.insertRecord(record: record);
        setState(() {});
      }
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
            puzzleCompleteAlertCallback: showPuzzleCompleteAlert,
          ),
        );
        state.setInitialPuzzlePiecePosition(i);
      }

      if (complete) {
        state.setPuzzleComplete(complete);
        puzzleCompleteDb();
      }

      return imagePieceList;
    }

    getSingleRecord() async {
      int best = 0;
      List<Map<String, dynamic>> record =
          await dbProvider.getSingleRecord(puzzleName: widget.readableName);

      if (record.length > 0) best = record[0]['bestMoves'];
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
                Spacer(),
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.readableName,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              'Moves: ${state.getMoves}',
                            ),
                            FutureBuilder(
                              future: getSingleRecord(),
                              initialData: 0,
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                Widget bestMoves;

                                if (snapshot.hasData) {
                                  int moves = snapshot.data;
                                  bestMoves = Text('Best moves: $moves');
                                } else {
                                  bestMoves = Text('Best moves: 0');
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 3,
                        color: Color(0xff000000),
                        // child: Text("Hint"),
                        child: Icon(Icons.search),
                        onPressed: () =>
                            Navigator.of(context).push(_customScaleRoute()),
                      ),
                      RaisedButton(
                        elevation: 3,
                        color: Color(0xff000000),
                        // child: Text("Quit"),
                        child: Icon(Icons.close),
                        onPressed: () => quitGame(),
                      ),
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
