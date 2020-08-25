import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5195845937584384~1650400197';
    }
    // else if (Platform.isIOS) {
    //   return '<YOUR_IOS_ADMOB_APP_ID>';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5195845937584384/9780171654';
    }
    // else if (Platform.isIOS) {
    //   return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5195845937584384/4174290052';
    }
    //  else if (Platform.isIOS) {
    //   return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    // }
    else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
