import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~4354546703";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8865242552";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/7049598008";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

// class AdManager {
//   static String get appId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-5195845937584384~1650400197";
//     }
//     // else if (Platform.isIOS) {
//     //   return "<YOUR_IOS_ADMOB_APP_ID>";
//     // }
//     else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-5195845937584384/9780171654";
//     }
//     // else if (Platform.isIOS) {
//     //   return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
//     // }
//     else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   // static String get interstitialAdUnitId {
//   //   if (Platform.isAndroid) {
//   //     return "<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>";
//   //   } else if (Platform.isIOS) {
//   //     return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
//   //   } else {
//   //     throw new UnsupportedError("Unsupported platform");
//   //   }
//   // }

//   // static String get rewardedAdUnitId {
//   //   if (Platform.isAndroid) {
//   //     return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
//   //   } else if (Platform.isIOS) {
//   //     return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
//   //   } else {
//   //     throw new UnsupportedError("Unsupported platform");
//   //   }
//   // }
// }
