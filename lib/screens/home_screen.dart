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
import '../data/images_data.dart';
import '../components/polaroid.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AssetImage bgImage;
  List<AssetImage> imageAssetCats;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    bgImage = AssetImage('assets/images/background.png');
    imageAssetCats = Images.imageList
        .map((e) =>
            AssetImage('assets/images/categories/${e["categoryName"]}_cat.png'))
        .toList();

    // _initAdMob().then((_) {
    //   print('Admob loaded');
    // }, onError: (error) => print(error));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(bgImage, context);

    imageAssetCats.forEach((image) {
      precacheImage(image, context);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    final double deviceHeight = MediaQuery.of(context).size.height;

    GameStateProvider state = Provider.of<GameStateProvider>(context);
    DeviceProvider deviceState = Provider.of<DeviceProvider>(context);

    state.setScreenWidth(width: MediaQuery.of(context).size.width - 20);

    deviceState.setUseMobileLayout(useMobileLayout: useMobileLayout);
    deviceState.setDeviceHeight(height: deviceHeight);
    deviceState.setGridSize(useMobile: useMobileLayout);

    // var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    // print("width: $w height:$h");

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: bgImage,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: deviceState.getDeviceHeight * 0.2),
                child: Button(
                  buttonText: 'Play!',
                  action: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SelectCategory(),
                    ),
                  ),
                ),
              ),
            ),
            Polaroid(
              alignment: Alignment.topLeft,
              angle: -math.pi / 6,
              beginPosition: Offset(-1, -1),
              endPosition: Offset(0, 0),
              image: "eiffel_tower",
              startInterval: 0.1,
            ),
            Polaroid(
              alignment: Alignment.bottomRight,
              angle: math.pi / 6,
              beginPosition: Offset(1, 1),
              endPosition: Offset(0, 0),
              image: "elephant",
              startInterval: 0.3,
            ),
            // Polaroid(
            //   alignment: Alignment.topLeft,
            //   angle: 20,
            //   beginPosition: Offset(-1, -1),
            //   endPosition: Offset(0, 0.2),
            //   image: "eiffel_tower",
            //   startInterval: 0.1,
            // ),
            // Polaroid(
            //   alignment: Alignment.topLeft,
            //   angle: 20,
            //   beginPosition: Offset(-1, -1),
            //   endPosition: Offset(0, 0.2),
            //   image: "eiffel_tower",
            //   startInterval: 0.1,
            // ),
          ],
        ),
      ),
    );
  }
}
