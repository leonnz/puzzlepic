import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/device_provider.dart';

class CustomTextTheme {
// Select Category Screen and Select Picture Screen
  // CustomTextTheme;

  static DeviceProvider deviceProvider = DeviceProvider();

  static TextStyle homeScreenAppName() {
    return GoogleFonts.satisfy(
      fontSize: deviceProvider.getUseMobileLayout ? 80 : 150,
      letterSpacing: 0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        const Shadow(
          blurRadius: 5,
          color: Colors.purple,
          offset: Offset(1, 1),
        )
      ],
    );
  }

  static TextStyle playButtonText() {
    return GoogleFonts.satisfy(
      fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
      letterSpacing: 10,
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );
  }

  static TextStyle selectScreenTitleTextStyle(BuildContext context) {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
      letterSpacing: 1,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      shadows: const <Shadow>[
        Shadow(
          blurRadius: 1,
          color: Colors.white70,
          offset: Offset(1, 1),
        )
      ],
    );
  }

  static TextStyle buttonTextStyle() {
    return GoogleFonts.roboto(letterSpacing: 1);
  }

  static TextStyle selectPictureButtonTextStyle() {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 25,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenImageTitle() {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 30 : 45,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  static TextStyle selectPictureScreenCompletedTextStyle() {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 14 : 22,
      letterSpacing: 1,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      shadows: const <Shadow>[
        Shadow(
          blurRadius: 1,
          color: Colors.white,
          offset: Offset(1, 1),
        )
      ],
    );
  }

  static TextStyle puzzleScreenPictureSubTitle() {
    return GoogleFonts.roboto(
      fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
      fontStyle: FontStyle.italic,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenMovesCounter() {
    return GoogleFonts.roboto(
      fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenQuitAlertTitle() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenQuitAlertContent() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenQuitAlertButtonText() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
    );
  }

  static TextStyle puzzleScreenCompleteAlertTitle() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenCompleteAlertContent() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenCompleteAlertButtonText() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
    );
  }
}
