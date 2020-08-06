import 'dart:async';
import 'dart:io';

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:audioplayers/audio_cache.dart';

import '../ad_manager.dart';
import '../components/_shared/loading_animation.dart';
import '../components/_shared/mute_button.dart';
import '../components/home_screen/play_button.dart';
import '../components/home_screen/polaroid.dart';
import '../components/home_screen/puzzle_pic_logo.dart';
import '../components/home_screen/shop_button.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/element_theme.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<AssetImage> imagesToPrecache;
  bool precacheImagesCompleted;

  AnimationController _polaroidSlideController;
  AnimationController _playButtonSlideController;
  AnimationController _shopButtonSlideController;
  AnimationController _puzzlePicSlideController;

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  Future<void> checkInternetConnection(
      {DeviceProvider deviceProvider, ShopProvider shopProvider}) async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        deviceProvider.setHasInternetConnection(connection: true);
        shopProvider.initialize();
      }
    } on SocketException catch (_) {}
  }

  @override
  void initState() {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _initAdMob().then((_) {}, onError: (void error) => null);
    checkInternetConnection(deviceProvider: deviceProvider, shopProvider: shopProvider);

    deviceProvider.setAudioCache(audioCache: AudioCache(prefix: 'audio/'));

    precacheImagesCompleted = false;
    imagesToPrecache = <AssetImage>[
      const AssetImage('assets/images/background.png'),
      const AssetImage('assets/images/_polaroids/polaroid_eiffel_tower.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_daisies.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_sea_turtle.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_taj_mahal.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_pyramids.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_grand_canyon.jpg'),
    ];

    // for (final Map<String, dynamic> imageCategory in Images.imageList) {
    //   // Category images
    //   imagesToPrecache.add(
    //     AssetImage('assets/images/_categories/${imageCategory["categoryName"]}_cat.png'),
    //   );
    //   // Category banners
    //   imagesToPrecache.add(
    //     AssetImage('assets/images/_categories/${imageCategory["categoryName"]}_banner.png'),
    //   );

    //   // Select picture screen thumbnails
    //   for (final Map<String, dynamic> image in List<Map<String, dynamic>>.from(
    //       imageCategory['categoryImages'] as Iterable<dynamic>)) {
    //     imagesToPrecache.add(AssetImage(
    //         'assets/images/${imageCategory['categoryName']}/${image['assetName']}_full_mini.jpg'));
    //   }
    // }

    _polaroidSlideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shopButtonSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _playButtonSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _puzzlePicSlideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    for (int i = 0; i < imagesToPrecache.length; i++) {
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
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context);
    DeviceProvider.deviceScreenHeight = MediaQuery.of(context).size.height;
    GameProvider.screenWidth = MediaQuery.of(context).size.width - 20;

    final bool useMobileLayout = MediaQuery.of(context).size.shortestSide < 600;
    deviceProvider.setUseMobileLayout(useMobileLayout: useMobileLayout);

    return Container(
      decoration: CustomElementTheme.screenBackgroundBoxDecoration(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
        body: precacheImagesCompleted
            ? Stack(
                children: <Widget>[
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.bottomRight,
                    angle: math.pi / 6,
                    beginPosition: const Offset(1, 1),
                    endPosition: const Offset(0.3, 0),
                    image: 'grand_canyon',
                    startInterval: 0.4,
                  ),
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.bottomLeft,
                    angle: -math.pi / 10,
                    beginPosition: const Offset(-1.5, 1.5),
                    endPosition: const Offset(-0.2, 0.1),
                    image: 'pyramids',
                    startInterval: 0.2,
                  ),
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.topLeft,
                    angle: -math.pi / 6,
                    beginPosition: const Offset(-1, -1),
                    endPosition: const Offset(0, 0),
                    image: 'daisies',
                    startInterval: 0.1,
                  ),
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.centerLeft,
                    angle: math.pi / 7,
                    beginPosition: const Offset(-1.5, 0),
                    endPosition: const Offset(0, 0),
                    image: 'sea_turtle',
                    startInterval: 0.3,
                  ),
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.centerRight,
                    angle: -math.pi / 9,
                    beginPosition: const Offset(1.5, 0),
                    endPosition: const Offset(0.2, 0),
                    image: 'taj_mahal',
                    startInterval: 0.1,
                  ),
                  Polaroid(
                    polaroidSlideController: _polaroidSlideController,
                    alignment: Alignment.topRight,
                    angle: math.pi / 8,
                    beginPosition: const Offset(1.5, -1),
                    endPosition: const Offset(0.2, -0.2),
                    image: 'eiffel_tower',
                    startInterval: 0.3,
                  ),
                  const MuteButton(),
                  PlayButton(
                    playButtonSlideController: _playButtonSlideController,
                    shopButtonSlideController: _shopButtonSlideController,
                    puzzlePicSlideController: _puzzlePicSlideController,
                    polaroidSlideController: _polaroidSlideController,
                  ),
                  ShopButton(
                    shopButtonSlideController: _shopButtonSlideController,
                  ),
                  PuzzlePicLogo(
                    puzzlePicSlideController: _puzzlePicSlideController,
                  ),
                ],
              )
            : const LoadingAnimation(),
      ),
    );
  }
}
