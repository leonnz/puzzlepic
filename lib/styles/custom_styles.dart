import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/device_provider.dart';

class CustomTextTheme {
// Select Category Screen and Select Picture Screen
  CustomTextTheme({this.deviceProvider});

  DeviceProvider deviceProvider;

  TextStyle homeScreenAppName(BuildContext context) {
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

  TextStyle playButtonText(BuildContext context) {
    return GoogleFonts.satisfy(
      fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
      letterSpacing: 10,
      fontWeight: FontWeight.bold,
      color: Colors.purple,
    );
  }

  TextStyle selectScreenTitleTextStyle(BuildContext context) {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
      letterSpacing: 1,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 1,
          color: Colors.white70,
          offset: const Offset(1, 1),
        )
      ],
    );
  }

  TextStyle buttonTextStyle() {
    return GoogleFonts.roboto(letterSpacing: 1);
  }

  TextStyle selectPictureButtonTextStyle() {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 25,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenImageTitle() {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 30 : 45,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  TextStyle selectPictureScreenCompletedTextStyle() {
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

  TextStyle puzzleScreenPictureSubTitle() {
    return GoogleFonts.roboto(
      fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
      fontStyle: FontStyle.italic,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenMovesCounter() {
    return GoogleFonts.roboto(
      fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenQuitAlertTitle() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenQuitAlertContent() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenQuitAlertButtonText() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
    );
  }

  TextStyle puzzleScreenCompleteAlertTitle() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenCompleteAlertContent() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
      color: Colors.black,
    );
  }

  TextStyle puzzleScreenCompleteAlertButtonText() {
    return TextStyle(
      fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
    );
  }
}
