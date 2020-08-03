import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../../ad_manager.dart';
import '../../data/db_provider.dart';
import '../../data/puzzle_record_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/image_piece_provider.dart';
import 'puzzle_card_image_piece.dart';

class PuzzleCardImageBoard extends StatefulWidget {
  const PuzzleCardImageBoard({
    Key key,
  }) : super(key: key);

  @override
  _PuzzleCardImageBoardState createState() => _PuzzleCardImageBoardState();
}

class _PuzzleCardImageBoardState extends State<PuzzleCardImageBoard> {
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
        break;
      default:
    }
  }

  @override
  void initState() {
    _isInterstitialAdReady = false;

    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    _loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    Future<void> puzzleCompleteDb() async {
      GameProvider.puzzleComplete = true;

      final DBProviderDb dbProvider = DBProviderDb();

      final List<String> currentRecords = await dbProvider.getRecords();

      if (currentRecords.contains(gameProvider.getReadableName)) {
        final List<Map<String, dynamic>> existingRecord =
            await dbProvider.getSingleRecord(puzzleName: gameProvider.getReadableName);
        final int existingRecordBestMoves = existingRecord[0]['bestMoves'] as int;

        if (gameProvider.getMoves < existingRecordBestMoves) {
          // Sets the best moves to the previous best moves, so the complete puzzle alert can calculate if it is a new best.
          gameProvider.setBestMoves(moves: existingRecordBestMoves);
          dbProvider.updateRecord(
              moves: gameProvider.getMoves, puzzleName: gameProvider.getReadableName);
        }
      } else {
        gameProvider.setBestMoves(moves: gameProvider.getMoves);
        final PuzzleRecord record = PuzzleRecord(
          puzzleName: gameProvider.getReadableName,
          puzzleCategory: gameProvider.getImageCategory,
          complete: 'true',
          moves: gameProvider.getMoves,
        );

        dbProvider.insertRecord(record: record);
      }
    }

    List<ImagePiece> generateImagePieces({int numberOfPieces, bool complete}) {
      final List<ImagePiece> imagePieceList = <ImagePiece>[];

      // Always produce 1 less image piece that the grid size
      for (int i = 1; i <= numberOfPieces; i++) {
        imagePieceList.add(
          ImagePiece(
            pieceNumber: i,
            lastPiece: complete,
            interstitialAd: _interstitialAd,
            isInterstitialAdReady: _isInterstitialAdReady,
          ),
        );
        gameProvider.setInitialPuzzlePiecePosition(i);
      }

      if (complete) {
        GameProvider.puzzleComplete = complete;
        puzzleCompleteDb();
      }

      return imagePieceList;
    }

    return ChangeNotifierProvider<ImagePieceProvider>(
      create: (BuildContext context) => ImagePieceProvider(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: gameProvider.getScreenWidth,
          height: gameProvider.getScreenWidth,
          color: Colors.grey,
          child: gameProvider.getPuzzleComplete
              ? Stack(
                  children: generateImagePieces(
                    numberOfPieces: gameProvider.getTotalGridSize,
                    complete: true,
                  ),
                )
              : Stack(
                  children: generateImagePieces(
                    numberOfPieces: gameProvider.getTotalGridSize - 1,
                    complete: false,
                  ),
                ),
        ),
      ),
    );
  }
}
