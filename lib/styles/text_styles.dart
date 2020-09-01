import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/device_provider.dart';

final TextStyle kHomeScreenAppName = GoogleFonts.satisfy(
  fontSize: DeviceProvider.shortestSide / 5,
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

final TextStyle kPlayButtonText = GoogleFonts.satisfy(
  fontSize: DeviceProvider.shortestSide / 18,
  letterSpacing: 10,
  fontWeight: FontWeight.bold,
  color: Colors.purple,
);

final TextStyle kSelectScreenTitleTextStyle = GoogleFonts.solway(
  fontSize: DeviceProvider.shortestSide / 18,
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

final TextStyle kButtonTextStyle = GoogleFonts.roboto(letterSpacing: 1);

final TextStyle kSelectPictureButtonTextStyle = GoogleFonts.solway(
  fontSize: DeviceProvider.shortestSide / 28,
  color: Colors.black,
);

final TextStyle kPuzzleScreenImageTitle = GoogleFonts.solway(
  fontSize: DeviceProvider.shortestSide / 15,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kSelectPictureScreenCompletedTextStyle = GoogleFonts.solway(
  fontSize: DeviceProvider.shortestSide / 32,
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

final TextStyle kPuzzleScreenPictureSubTitle = GoogleFonts.roboto(
  fontSize: DeviceProvider.shortestSide / 30,
  fontStyle: FontStyle.italic,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kPuzzleScreenMovesCounter = GoogleFonts.roboto(
  fontSize: DeviceProvider.shortestSide / 30,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertTitle = TextStyle(
  fontSize: DeviceProvider.shortestSide / 25,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertContent = TextStyle(
  fontSize: DeviceProvider.shortestSide / 32,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertButtonText = TextStyle(
  fontSize: DeviceProvider.shortestSide / 32,
);

final TextStyle kPuzzleScreenCompleteAlertTitle = TextStyle(
  fontSize: DeviceProvider.shortestSide / 25,
  color: Colors.black,
);

final TextStyle kPuzzleScreenCompleteAlertContent = TextStyle(
  fontSize: DeviceProvider.shortestSide / 32,
  color: Colors.black,
);

final TextStyle kPuzzleScreenCompleteAlertButtonText = TextStyle(
  fontSize: DeviceProvider.shortestSide / 32,
);
