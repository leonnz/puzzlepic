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
  runApp(PuzzlePicApp());
}

class PuzzlePicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBProviderDb().database;

    ///DEV ONLY
    // dbProvider.deleteDb();

    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<GameProvider>(create: (_) => GameProvider()),
        ChangeNotifierProvider<DeviceProvider>(create: (_) => DeviceProvider()),
        ChangeNotifierProvider<ShopProvider>(create: (_) => ShopProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Puzzle Pic',
        home: Home(),
      ),
    );
  }
}
