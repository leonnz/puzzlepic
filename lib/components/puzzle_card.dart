import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import '../components/image_piece.dart';
import '../components/puzzle_complete_alert.dart';
import '../data/puzzle_record_model.dart';
import '../providers/game_provider.dart';
import '../providers/device_provider.dart';
import '../data/db_provider.dart';
import '../styles/customStyles.dart';
import '../screens/puzzle_screen.dart';

class PuzzleCard extends StatelessWidget {
  const PuzzleCard(
      {Key key,
      @required this.gameProvider,
      @required this.widget,
      @required this.interstitialAd,
      @required this.isInterstitialAdReady})
      : super(key: key);

  final GameProvider gameProvider;
  final PuzzleScreen widget;
  final InterstitialAd interstitialAd;
  final bool isInterstitialAdReady;

  Future<int> getSingleRecord() async {
    DBProviderDb dbProvider = DBProviderDb();
    int best = 0;
    List<Map<String, dynamic>> record =
        await dbProvider.getSingleRecord(puzzleName: widget.imageReadableName);

    if (record.length > 0) {
      best = record[0]['bestMoves'];
    }
    return best;
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
            moves: gameProvider.getMoves, puzzleName: widget.imageReadableName);
        // setState(() {});
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
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);

    Future<dynamic> showPuzzleCompleteAlert() {
      return showDialog(
        context: context,
        builder: (context) => PuzzleCompleteAlert(
          readableName: widget.imageReadableName,
          readableFullname: widget.imageReadableFullname,
          fullAd: interstitialAd,
          fullAdReady: isInterstitialAdReady,
          moves: gameProvider.getMoves,
          bestMoves: gameProvider.getBestMoves,
        ),
      ).then((value) {
        if (value) {
          // setState(() {});
        }
      });
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

    return Container(
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
                style: CustomTextTheme(deviceProvider: deviceProvider)
                    .puzzleScreenImageTitle(),
              ),
            ),
            widget.imageTitle != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.imageTitle,
                      style: CustomTextTheme(deviceProvider: deviceProvider)
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
                    style: CustomTextTheme(deviceProvider: deviceProvider)
                        .puzzleScreenMovesCounter(),
                  ),
                  FutureBuilder(
                    future: getSingleRecord(),
                    initialData: 0,
                    builder: (context, AsyncSnapshot<int> snapshot) {
                      Widget bestMoves;

                      if (snapshot.hasData) {
                        int moves = snapshot.data;
                        bestMoves = Text(
                          'Best moves: $moves',
                          style: CustomTextTheme(deviceProvider: deviceProvider)
                              .puzzleScreenMovesCounter(),
                        );
                      } else {
                        bestMoves = Text(
                          'Best moves: 0',
                          style: CustomTextTheme(deviceProvider: deviceProvider)
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
                            gameProvider.getTotalGridSize - 1, false),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
