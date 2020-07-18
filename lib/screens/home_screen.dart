import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/button.dart';
import 'package:provider/provider.dart';
import 'package:PuzzlePic/providers/game_state_provider.dart';
import '../providers/device_provider.dart';
import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AssetImage bgImage;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    bgImage = AssetImage('assets/images/checker_background.png');
    _initAdMob().then((_) {
      print('Admob loaded');
    }, onError: (error) => print(error));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final double deviceHeight = MediaQuery.of(context).size.height;

    GameStateProvider state = Provider.of<GameStateProvider>(context);
    DeviceProvider deviceState = Provider.of<DeviceProvider>(context);

    state.setScreenWidth(width: MediaQuery.of(context).size.width - 20);
    state.setScreenHeight(height: MediaQuery.of(context).size.height);

    deviceState.setUseMobileLayout(useMobileLayout: useMobileLayout);
    deviceState.setDeviceHeight(height: deviceHeight);
    deviceState.setGridSize(
      useMobile: useMobileLayout,
      orientation: orientation,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: bgImage,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: deviceState.getDeviceHeight * 0.2),
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
