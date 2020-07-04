import 'package:flutter/material.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        title: 'Puzzle Pic',
        theme: ThemeData(
          fontFamily: 'Rabelo',
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
        },
      ),
    );
  }
}
