import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/button.dart';
import 'package:provider/provider.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';

import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../data/puzzle_record_model.dart';
import '../data/puzzle_record_db.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  dbTest() async {
    PuzzleRecordDb prDb = PuzzleRecordDb();

    Future<Database> database = prDb.initDB();

    final tajMahal = PuzzleRecord(
      id: 0,
      puzzleName: 'tajmahal',
      complete: 'true',
      bestMoves: 0,
    );

    await prDb.insertRecord(tajMahal, database);

    print(
      await prDb.getRecords(database).then(
            (value) => value.forEach(
              (element) {
                print(element.complete);
              },
            ),
          ),
    );
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
