import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'select_category_screen.dart';
import '../components/play_button.dart';
import 'package:provider/provider.dart';
import 'package:PuzzlePic/providers/game_state_provider.dart';
import '../providers/device_provider.dart';
import '../ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';
import '../data/images_data.dart';
import '../components/polaroid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../styles/customStyles.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<AssetImage> imagesToPrecache;

  Animation<Offset> _puzzlePicAnimation;

  AnimationController _polaroidController;
  AnimationController _playButtonController;
  AnimationController _puzzlePicAnimationController;
  bool precacheImagesCompleted = false;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  void initState() {
    imagesToPrecache = [
      AssetImage('assets/images/background.png'),
      AssetImage('assets/images/polaroids/polaroid_eiffel_tower.jpg'),
      AssetImage('assets/images/polaroids/polaroid_daisies.jpg'),
      AssetImage('assets/images/polaroids/polaroid_sea_turtle.jpg'),
      AssetImage('assets/images/polaroids/polaroid_taj_mahal.jpg'),
      AssetImage('assets/images/polaroids/polaroid_pyramids.jpg'),
      AssetImage('assets/images/polaroids/polaroid_grand_canyon.jpg'),
    ];

    Images.imageList.forEach((imageCategory) {
      // Category images
      imagesToPrecache.add(
        AssetImage(
            'assets/images/categories/${imageCategory["categoryName"]}_cat.png'),
      );
      // Category banners
      imagesToPrecache.add(
        AssetImage(
            'assets/images/categories/${imageCategory["categoryName"]}_banner.png'),
      );

      // Select picture screen thumbnails
      List<dynamic>.from(imageCategory['categoryImages']).forEach((image) {
        imagesToPrecache.add(AssetImage(
            'assets/images/${imageCategory['categoryName']}/${image['assetName']}_full_mini.jpg'));
      });
    });

    _polaroidController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _puzzlePicAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..forward();

    _puzzlePicAnimation = Tween<Offset>(
      begin: Offset(0, -2),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _puzzlePicAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    // _initAdMob().then((_) {
    //   print('Admob loaded');
    // }, onError: (error) => print(error));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    for (var i = 0; i < imagesToPrecache.length; i++) {
      precacheImage(imagesToPrecache[i], context).then((_) {
        if (i == imagesToPrecache.length - 1) {
          setState(() {
            precacheImagesCompleted = true;
          });
        }
      });
    }

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
          image: AssetImage('assets/images/background.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
        body: precacheImagesCompleted
            ? Stack(
                children: <Widget>[
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.bottomRight,
                    angle: math.pi / 6,
                    beginPosition: Offset(1, 1),
                    endPosition: Offset(0.3, 0),
                    image: "grand_canyon",
                    startInterval: 0.4,
                  ),
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.bottomLeft,
                    angle: -math.pi / 10,
                    beginPosition: Offset(-1.5, 1.5),
                    endPosition: Offset(-0.2, 0.1),
                    image: "pyramids",
                    startInterval: 0.2,
                  ),
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.topLeft,
                    angle: -math.pi / 6,
                    beginPosition: Offset(-1, -1),
                    endPosition: Offset(0, 0),
                    image: "daisies",
                    startInterval: 0.1,
                  ),
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.centerLeft,
                    angle: math.pi / 7,
                    beginPosition: Offset(-1.5, 0),
                    endPosition: Offset(0, 0),
                    image: "sea_turtle",
                    startInterval: 0.3,
                  ),
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.centerRight,
                    angle: -math.pi / 9,
                    beginPosition: Offset(1.5, 0),
                    endPosition: Offset(0.2, 0),
                    image: "taj_mahal",
                    startInterval: 0.1,
                  ),
                  Polaroid(
                    animationController: _polaroidController,
                    alignment: Alignment.topRight,
                    angle: math.pi / 8,
                    beginPosition: Offset(1.5, -1),
                    endPosition: Offset(0.2, -0.2),
                    image: "eiffel_tower",
                    startInterval: 0.3,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: deviceState.getDeviceHeight * 0.2),
                      child: PlayButton(
                          slideAnimationController: _playButtonController,
                          buttonText: 'Play!',
                          action: () {
                            _playButtonController.reverse();
                            _puzzlePicAnimationController.reverse();
                            _polaroidController.reverse().then((_) async {
                              var result = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SelectCategory(),
                                ),
                              );

                              if (result) {
                                _polaroidController.forward();
                                _playButtonController.forward();
                                _puzzlePicAnimationController.forward();
                              }
                            });
                          }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SlideTransition(
                      position: _puzzlePicAnimation,
                      child: Container(
                        color: Color.fromRGBO(147, 112, 219, 0.2),
                        margin: EdgeInsets.only(
                          top: deviceState.getDeviceHeight * 0.2,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 50,
                          ),
                          child: Text(
                            'Puzzle Pic',
                            textAlign: TextAlign.center,
                            style: CustomTextTheme(deviceProvider: deviceState)
                                .homeScreenAppName(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitFadingFour(
                    color: Colors.purple,
                    size: deviceState.getUseMobileLayout ? 50 : 80,
                  ),
                ),
              ),
      ),
    );
  }
}
