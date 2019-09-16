import 'dart:io';

import 'package:palpites_da_loteria/defaults/Constants.dart';

class AdUnits {
  static final String bannerTest = "ca-app-pub-3940256099942544/6300978111";
  static final String interstitialTest = "ca-app-pub-3940256099942544/1033173712";
  static final String interstitialVideoTest = "ca-app-pub-3940256099942544/8691691433";
  static final String rewardVideoTest = "ca-app-pub-3940256099942544/5224354917";

  static final String androidApiKey = "ca-app-pub-9921693044196842~4393626727";
  static final String androidConcursosBanner = "ca-app-pub-9921693044196842/2888973360";
  static final String androidSorteioBanner = "ca-app-pub-9921693044196842/1209494959";
  static final String androidSorteioInterstitial = "ca-app-pub-9921693044196842/1209850177";

  static final String iosApiKey = "ca-app-pub-9921693044196842~2867650422";
  static final String iosConcursosBanner = "ca-app-pub-9921693044196842/3409548238";
  static final String iosSorteioBanner = "ca-app-pub-9921693044196842/3859515509";
  static final String iosSorteioInterstitial = "ca-app-pub-9921693044196842/3623071156";

  static String getAppId() {
    if (Platform.isIOS) {
      return iosApiKey;
    } else if (Platform.isAndroid) {
      return androidApiKey;
    }
    return null;
  }

  static String getConcursosBannerId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosConcursosBanner;
      } else if (Platform.isAndroid) {
        return androidConcursosBanner;
      }
    }
    return bannerTest;
  }

  static String getSorteioBannerId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosSorteioBanner;
      } else if (Platform.isAndroid) {
        return androidSorteioBanner;
      }
    }
    return bannerTest;
  }

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosSorteioInterstitial;
      } else if (Platform.isAndroid) {
        return androidSorteioInterstitial;
      }
    }
    return interstitialTest;
  }
}
