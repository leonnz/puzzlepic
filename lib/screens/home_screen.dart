import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/button.dart';
import 'package:provider/provider.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';

import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../data/puzzle_record_model.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  dbTest() async {
    // Open the database and store the reference.
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'puzzle_record.db'),

      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE puzzle_record(id INTEGER PRIMARY KEY, puzzleName TEXT, complete TEXT, bestMoves INTEGER)",
        );
      },

      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    Future<void> insertRecord(PuzzleRecord pr) async {
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'puzzle_record',
        pr.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Create a Dog and add it to the dogs table.
    final tajMahal = PuzzleRecord(
      id: 0,
      puzzleName: 'tajmahal',
      complete: 'true',
      bestMoves: 0,
    );

    await insertRecord(tajMahal);

    Future<List<PuzzleRecord>> getRecords() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('puzzle_record');
      await db.close();

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return PuzzleRecord(
          id: maps[i]['id'],
          puzzleName: maps[i]['puzzleName'],
          complete: maps[i]['complete'],
          bestMoves: maps[i]['bestMoves'],
        );
      });
    }

    // Now, use the method above to retrieve all the dogs.
    print(await getRecords().then((value) => value.forEach((element) {
          print(element.complete);
        })));

    // Close the database
  }

  @override
  Widget build(BuildContext context) {
    dbTest();

    var state = Provider.of<GameStateProvider>(context);
    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width - 20);
    return Scaffold(
      body: FutureBuilder<void>(
          future: _initAdMob(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            List<Widget> children = <Widget>[
              Image(
                width: state.getScreenWidth * 0.7,
                image: AssetImage('assets/images/puzzlepiclogo.png'),
              ),
            ];

            if (snapshot.hasData) {
              children.add(
                Center(
                  child: Button(
                    buttonText: 'Play!',
                    action: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCategory(),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              children.addAll(<Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
              ]);
            } else {
              children.add(SizedBox(
                child: CircularProgressIndicator(),
                width: 48,
                height: 48,
              ));
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff501E5D),
                    Color(0xff9E2950),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              ),
            );
          }),
    );
  }
}
