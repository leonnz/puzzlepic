import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import './data/db_provider.dart';
import './providers/device_provider.dart';
import './providers/game_provider.dart';
import './providers/shop_provider.dart';
import './screens/home_screen.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(const PuzzlePicApp());
}

class PuzzlePicApp extends StatefulWidget {
  const PuzzlePicApp({Key key}) : super(key: key);

  @override
  _PuzzlePicAppState createState() => _PuzzlePicAppState();
}

class _PuzzlePicAppState extends State<PuzzlePicApp> {
  @override
  void initState() {
    DBProviderDb().database;

    ///DEV ONLY delete the database
    // final DBProviderDb dbProvider = DBProviderDb();
    // dbProvider.deleteDb();

    SystemChrome.setEnabledSystemUIOverlays(
        <SystemUiOverlay>[SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<GameProvider>(create: (_) => GameProvider()),
        ChangeNotifierProvider<DeviceProvider>(create: (_) => DeviceProvider()),
        ChangeNotifierProvider<ShopProvider>(create: (_) => ShopProvider()),
      ],
      child: const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Puzzle Pic',
          home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
              child: Home()),
        ),
      ),
    );
  }
}
