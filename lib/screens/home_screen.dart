import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:audioplayers/audio_cache.dart';

import '../ad_manager.dart';
import '../components/_shared/loading_animation.dart';

import '../components/home_screen/home_screen_stack.dart';
import '../data/images_data.dart';
import '../providers/device_provider.dart';
import '../providers/game_provider.dart';
import '../providers/shop_provider.dart';
import '../styles/box_decoration_styes.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AssetImage> _imagesToPrecache;
  bool _precacheImagesCompleted;

  void _checkRemoveAdsPurchased(
      {bool shopAvailable, ShopProvider shopProvider, DeviceProvider deviceProvider}) {
    if (shopAvailable) {
      final PurchaseDetails adPurchased = shopProvider.getPastPurchases.firstWhere(
        (PurchaseDetails purchase) => purchase.productID == shopProvider.getRemoveAdProductId,
        orElse: () => null,
      );
      if (adPurchased == null) {
        shopProvider.showBannerAd();
      }
    }
    // Dev only
    shopProvider.showBannerAd();
  }

  Future<void> _checkShopAvailability(
      {DeviceProvider deviceProvider, ShopProvider shopProvider}) async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        deviceProvider.setHasInternetConnection(connection: true);
        await _initAdMob().then((_) {}, onError: (void error) => null);
        final bool shopAvailable = await shopProvider.initialize();

        _checkRemoveAdsPurchased(
            shopAvailable: shopAvailable,
            shopProvider: shopProvider,
            deviceProvider: deviceProvider);
      }
    } on SocketException catch (_) {}
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  void _addImagestoCache() {
    _imagesToPrecache = <AssetImage>[
      const AssetImage('assets/images/background.png'),
      const AssetImage('assets/images/_polaroids/polaroid_eiffel_tower.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_daisies.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_sea_turtle.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_taj_mahal.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_pyramids.jpg'),
      const AssetImage('assets/images/_polaroids/polaroid_grand_canyon.jpg'),
    ];

    for (final Map<String, dynamic> imageCategory in Images.imageList) {
      _imagesToPrecache.add(
        AssetImage('assets/images/_categories/${imageCategory["categoryName"]}_cat.png'),
      );
      _imagesToPrecache.add(
        AssetImage('assets/images/_categories/${imageCategory["categoryName"]}_banner.png'),
      );

      for (final Map<String, dynamic> image in List<Map<String, dynamic>>.from(
          imageCategory['categoryImages'] as Iterable<dynamic>)) {
        _imagesToPrecache.add(AssetImage(
            'assets/images/${imageCategory['categoryName']}/${image['assetName']}_full_mini.jpg'));
      }
    }
  }

  void _cacheImages() {
    for (int i = 0; i < _imagesToPrecache.length; i++) {
      precacheImage(_imagesToPrecache[i], context).then((_) {
        if (i == _imagesToPrecache.length - 1) {
          setState(() {
            _precacheImagesCompleted = true;
          });
        }
      });
    }
  }

  @override
  void initState() {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _precacheImagesCompleted = false;

    deviceProvider.setAudioCache(audioCache: AudioCache(prefix: 'audio/'));
    _addImagestoCache();
    _checkShopAvailability(deviceProvider: deviceProvider, shopProvider: shopProvider);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _cacheImages();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final DeviceProvider deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

    DeviceProvider.deviceScreenHeight = MediaQuery.of(context).size.height;
    GameProvider.screenWidth = MediaQuery.of(context).size.width - 20;

    final bool useMobileLayout = MediaQuery.of(context).size.shortestSide < 600;
    deviceProvider.setUseMobileLayout(useMobileLayout: useMobileLayout);
    DeviceProvider.shortestSide = MediaQuery.of(context).size.shortestSide;
    DeviceProvider.longestSide = MediaQuery.of(context).size.longestSide;


    return Container(
      decoration: kScreenBackgroundBoxDecoration,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
          body: _precacheImagesCompleted ? const HomeScreenStack() : const LoadingAnimation(),
        ),
      ),
    );
  }
}
