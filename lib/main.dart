import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './providers/device_provider.dart';
import './providers/game_provider.dart';
import './screens/home_screen.dart';
import './data/db_provider.dart';

void main() => runApp(PuzzlePicApp());

class PuzzlePicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Init the database
    DBProviderDb().database;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff501E5D), //or set color with: Color(0xFF0000FF)
    ));

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Puzzle Pic',
        home: Home(),
      ),
    );
  }
}
