import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/device_provider.dart';

final DeviceProvider deviceProvider = DeviceProvider();

final TextStyle kHomeScreenAppName = GoogleFonts.satisfy(
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

final TextStyle kPlayButtonText = GoogleFonts.satisfy(
  fontSize: deviceProvider.getUseMobileLayout ? 24 : 40,
  letterSpacing: 10,
  fontWeight: FontWeight.bold,
  color: Colors.purple,
);

final TextStyle kSelectScreenTitleTextStyle = GoogleFonts.solway(
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

final TextStyle kButtonTextStyle = GoogleFonts.roboto(letterSpacing: 1);

final TextStyle kSelectPictureButtonTextStyle = GoogleFonts.solway(
  fontSize: deviceProvider.getUseMobileLayout ? 16 : 25,
  color: Colors.black,
);

final TextStyle kPuzzleScreenImageTitle = GoogleFonts.solway(
  fontSize: deviceProvider.getUseMobileLayout ? 30 : 45,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kSelectPictureScreenCompletedTextStyle = GoogleFonts.solway(
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

final TextStyle kPuzzleScreenPictureSubTitle = GoogleFonts.roboto(
  fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
  fontStyle: FontStyle.italic,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kPuzzleScreenMovesCounter = GoogleFonts.roboto(
  fontSize: deviceProvider.getUseMobileLayout ? 14 : 20,
  letterSpacing: 1,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertTitle = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertContent = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
  color: Colors.black,
);

final TextStyle kPuzzleScreenQuitAlertButtonText = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
);

final TextStyle kPuzzleScreenCompleteAlertTitle = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 20 : 25,
  color: Colors.black,
);

final TextStyle kPuzzleScreenCompleteAlertContent = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
  color: Colors.black,
);

final TextStyle kPuzzleScreenCompleteAlertButtonText = TextStyle(
  fontSize: deviceProvider.getUseMobileLayout ? 16 : 20,
);
