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

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AssetImage bgImage;
  List<AssetImage> imageAssetCats;

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<Offset> _offsetAnimation1;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    bgImage = AssetImage('assets/images/checker_background.png');
    imageAssetCats = Images.imageList
        .map((e) =>
            AssetImage('assets/images/categories/${e["categoryName"]}_cat.png'))
        .toList();

    // _initAdMob().then((_) {
    //   print('Admob loaded');
    // }, onError: (error) => print(error));

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    // Top left corner
    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1, -1),
      end: Offset(0, 0.2),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _offsetAnimation1 = Tween<Offset>(
      begin: Offset(-1, -1.5),
      end: Offset(0, 0.2),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.35, 1.0, curve: Curves.elasticOut),
      ),
    );

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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: bgImage,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: deviceState.getDeviceHeight * 0.2),
                child: Button(
                  buttonText: 'Play!',
                  action: () {
                    _controller.reverse().then(
                          (_) => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SelectCategory(),
                            ),
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
            Align(
              alignment: Alignment.topLeft,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Transform.rotate(
                  angle: 225,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    // color: Colors.red,
                    // width: state.getScreenWidth * 0.7,
                    // height: state.getScreenWidth * 0.7,
                    child: Image(
                      image: AssetImage(
                          'assets/images/polaroids/polaroid_eiffel_tower.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SlideTransition(
                position: _offsetAnimation1,
                child: Transform.rotate(
                  angle: 70,
                  child: Container(
                    // color: Colors.red,
                    width: state.getScreenWidth * 0.3,
                    height: state.getScreenWidth * 0.3,
                    child: Image(
                      image: AssetImage(
                          'assets/images/buildings/pyramids_full.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
