import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/button.dart';
import 'package:provider/provider.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    _initAdMob().then((_) {
      print('Admob loaded');
    }, onError: (error) => print(error));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<GameStateProvider>(context);

    state.setScreenWidth(screenwidth: MediaQuery.of(context).size.width - 20);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/checker_background.png')),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
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
            ),
            // Image(
            //   width: state.getScreenWidth * 0.7,
            //   image: AssetImage('assets/images/puzzlepiclogo.png'),
            // ),
          ],
        ),
      ),
    );
  }
}
