import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/db_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/game_provider.dart';
import '../../styles/customStyles.dart';

class PuzzleCardMoves extends StatelessWidget {
  const PuzzleCardMoves({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    final GameProvider gameProvider = Provider.of<GameProvider>(context);

    Future<int> getSingleRecord() async {
      final DBProviderDb dbProvider = DBProviderDb();
      int best = 0;
      final List<Map<String, dynamic>> record = await dbProvider
          .getSingleRecord(puzzleName: gameProvider.getReadableName);

      if (record.isNotEmpty) {
        best = record[0]['bestMoves'] as int;
      }
      return best;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Moves: ${gameProvider.getMoves}',
            style: CustomTextTheme(deviceProvider: deviceProvider)
                .puzzleScreenMovesCounter(),
          ),
          FutureBuilder<int>(
            future: getSingleRecord(),
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              Widget bestMoves;

              if (snapshot.hasData) {
                final int moves = snapshot.data;
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
    );
  }
}
