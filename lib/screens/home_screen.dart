import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/button.dart';
import 'package:provider/provider.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  Widget build(BuildContext context) {
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
                        CupertinoPageRoute(
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
