import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picturepuzzle/providers/game_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './data/db_provider.dart';

void main() => runApp(MyApp());

// TODO Splash screen
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
        title: 'Puzzle Pic',
        theme: ThemeData(
          fontFamily: 'Rabelo',
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
          textTheme: TextTheme(
            button: GoogleFonts.roboto(letterSpacing: 1),
            headline1: GoogleFonts.solway(
              fontSize: 22,
              letterSpacing: 1,
              color: Colors.black,
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
        home: Home(),
      ),
    );
  }
}
