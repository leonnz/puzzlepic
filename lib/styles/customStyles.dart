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

  static TextStyle buttonTextStyle(BuildContext context) {
    return GoogleFonts.roboto(letterSpacing: 1);
  }

  static TextStyle selectPictureButtonTextStyle(BuildContext context) {
    return GoogleFonts.solway(
      fontSize: 16,
      color: Colors.black,
    );
  }

  static TextStyle puzzleScreenImageTitle(BuildContext context) {
    return GoogleFonts.solway(
      fontSize: 30,
      letterSpacing: 1,
      color: Colors.black,
    );
  }

  static TextStyle selectPictureScreenCompletedTextStyle(BuildContext context) {
    return GoogleFonts.solway(
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
    );
  }

  static TextStyle puzzleScreenPictureTitle(BuildContext context) {
    return GoogleFonts.roboto(
      fontSize: 14,
      letterSpacing: 1,
      color: Colors.black,
    );
  }
}
