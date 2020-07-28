import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styles/customStyles.dart';
import '../../providers/game_provider.dart';
import '../../providers/device_provider.dart';
import '../../data/db_provider.dart';

class PuzzleCardMoves extends StatelessWidget {
  const PuzzleCardMoves({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    Future<int> getSingleRecord() async {
      DBProviderDb dbProvider = DBProviderDb();
      int best = 0;
      List<Map<String, dynamic>> record = await dbProvider.getSingleRecord(
          puzzleName: gameProvider.getReadableName);

      if (record.length > 0) {
        best = record[0]['bestMoves'];
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
    );
  }
}
