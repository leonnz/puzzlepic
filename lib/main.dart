import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
          textTheme: TextTheme(
            button: GoogleFonts.roboto(letterSpacing: 1),
            headline1: GoogleFonts.roboto(
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white,
            ),
            headline2: GoogleFonts.solway(
              fontSize: 20,
              color: Colors.black,
            ),
            headline3: GoogleFonts.solway(
              fontSize: 30,
              letterSpacing: 1,
              color: Colors.black,
            ),
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
