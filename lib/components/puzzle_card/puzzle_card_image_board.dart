import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../../data/db_provider.dart';
import '../../data/puzzle_record_model.dart';
import '../../providers/game_provider.dart';
import 'puzzle_card_image_piece.dart';

class PuzzleCardImageBoard extends StatelessWidget {
  const PuzzleCardImageBoard({
    Key key,
    @required this.interstitialAd,
    @required this.isInterstitialAdReady,
  }) : super(key: key);

  final InterstitialAd interstitialAd;
  final bool isInterstitialAdReady;

  @override
  Widget build(BuildContext context) {
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    void puzzleCompleteDb() async {
      gameProvider.setPuzzleComplete(true);

      final DBProviderDb dbProvider = DBProviderDb();

      final List<String> currentRecords = await dbProvider.getRecords();

      if (currentRecords.contains(gameProvider.getReadableName)) {
        final List<Map<String, dynamic>> existingRecord = await dbProvider
            .getSingleRecord(puzzleName: gameProvider.getReadableName);
        final int existingRecordBestMoves =
            existingRecord[0]['bestMoves'] as int;

        if (gameProvider.getMoves < existingRecordBestMoves) {
          // Sets the best moves to the previous best moves, so the complete puzzle alert can calculate if it is a new best.
          gameProvider.setBestMoves(moves: existingRecordBestMoves);
          dbProvider.updateRecord(
              moves: gameProvider.getMoves,
              puzzleName: gameProvider.getReadableName);
        }
      } else {
        gameProvider.setBestMoves(moves: gameProvider.getMoves);
        final record = PuzzleRecord(
          puzzleName: gameProvider.getReadableName,
          puzzleCategory: gameProvider.getImageCategory,
          complete: 'true',
          moves: gameProvider.getMoves,
        );

        dbProvider.insertRecord(record: record);
      }
    }

    List<ImagePiece> generateImagePieces(int numberOfPieces, bool complete) {
      List<ImagePiece> imagePieceList = <ImagePiece>[];

      // Always produce 1 less image piece that the grid size
      for (int i = 1; i <= numberOfPieces; i++) {
        imagePieceList.add(
          ImagePiece(
            pieceNumber: i,
            lastPiece: complete ? true : false,
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

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: gameProvider.getScreenWidth,
        height: gameProvider.getScreenWidth,
        color: Colors.grey,
        child: gameProvider.getPuzzleComplete
            ? Stack(
                children:
                    generateImagePieces(gameProvider.getTotalGridSize, true),
              )
            : Stack(
                children: generateImagePieces(
                    gameProvider.getTotalGridSize - 1, false),
              ),
      ),
    );
  }
}
