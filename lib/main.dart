import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:PuzzlePic/providers/game_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './data/db_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Init the database
    DBProviderDb().database;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff501E5D), //or set color with: Color(0xFF0000FF)
    ));

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Puzzle Pic',
        theme: ThemeData(
          fontFamily: 'Rabelo',
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
          textTheme: TextTheme(
            button: GoogleFonts.roboto(letterSpacing: 1),
            // Puzzle select screen title
            headline1: GoogleFonts.solway(
                fontSize: 24,
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                      blurRadius: 1,
                      color: Colors.white70,
                      offset: Offset(1, 1))
                ]),
            // Buttons
            headline2: GoogleFonts.solway(
              fontSize: 16,
              color: Colors.black,
            ),
            // Puzzle Screen title
            headline3: GoogleFonts.solway(
              fontSize: 30,
              letterSpacing: 1,
              color: Colors.black,
            ),
            // Puzzle select screen title complete counter
            headline4: GoogleFonts.roboto(
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              shadows: [
                Shadow(
                  blurRadius: 1,
                  color: Colors.white,
                  offset: Offset(1, 1),
                )
              ],
            ),
            headline5: GoogleFonts.roboto(
              fontSize: 24,
              letterSpacing: 1,
              color: Colors.black,
            ),
          ),
        ),
        home: Home(),
      ),
    );
  }
}
