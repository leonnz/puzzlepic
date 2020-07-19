import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/device_provider.dart';

class CustomTextTheme {
// Select Category Screen and Select Picture Screen

  DeviceProvider deviceProvider;

  CustomTextTheme({this.deviceProvider});

  TextStyle selectScreenTitleTextStyle(BuildContext context) {
    return GoogleFonts.solway(
      fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
      letterSpacing: 1,
      color: Colors.black,
      fontWeight: FontWeight.w500,
      shadows: [
        Shadow(
          blurRadius: 1,
          color: Colors.white70,
          offset: Offset(1, 1),
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
      shadows: [
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
      letterSpacing: 1,
      color: Colors.black,
    );
  }
}
