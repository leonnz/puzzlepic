import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle buttonTextStyle = GoogleFonts.roboto(letterSpacing: 1);

TextStyle selectScreenTitleTextStyle = GoogleFonts.solway(
  fontSize: 24,
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

TextStyle selectPictureButtonTextStyle = GoogleFonts.solway(
  fontSize: 16,
  color: Colors.black,
);

TextStyle puzzleScreenImageTitle = GoogleFonts.solway(
  fontSize: 30,
  letterSpacing: 1,
  color: Colors.black,
);

TextStyle selectPictureScreenCompletedTextStyle = GoogleFonts.solway(
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

TextStyle puzzleScreenPictureTitle = GoogleFonts.roboto(
  fontSize: 14,
  letterSpacing: 1,
  color: Colors.black,
);
