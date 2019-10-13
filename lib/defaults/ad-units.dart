import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';

class AdUnits {

  static final String androidApiKey = "ca-app-pub-9921693044196842~4393626727";
  static final String androidConcursosBanner = "ca-app-pub-9921693044196842/2888973360";
  static final String androidSorteioBanner = "ca-app-pub-9921693044196842/1209494959";
  static final String androidSorteioInterstitial = "ca-app-pub-9921693044196842/1209850177";

  static final String iosApiKey = "ca-app-pub-9921693044196842~2867650422";
  static final String iosConcursosBanner = "ca-app-pub-9921693044196842/3409548238";
  static final String iosSorteioBanner = "ca-app-pub-9921693044196842/3859515509";
  static final String iosSorteioInterstitial = "ca-app-pub-9921693044196842/3623071156";

  static BannerAd _concursosBanner;
  static BannerAd get concursosBanner => _concursosBanner;

  static double _bannerPadding = 50;
  static double get bannerPadding => _bannerPadding;

  static void instatiateBannerAd() {
    _concursosBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdUnits.getConcursosBannerId(),
      targetingInfo: MobileAdTargetingInfo(
          testDevices: [
            "30B81A47E3005ADC205D4BCECC4450E1",
            "F2EFF4F833C2BA2BE93D3A4A1098A125"
          ]
      ),
    );
  }

  static void showBannerAd() {
    _concursosBanner.isLoaded().then((isLoaded) {
      if (isLoaded) {
        _concursosBanner.show();
        _bannerPadding = 50;
      } else {
        instatiateBannerAd();
        _concursosBanner.load();
        _bannerPadding = 0;
      }
    });

  }

  static String getAppId() {
    if (Platform.isIOS) {
      return iosApiKey;
    } else if (Platform.isAndroid) {
      return androidApiKey;
    }
    return FirebaseAdMob.testAppId;
  }

  static String getConcursosBannerId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosConcursosBanner;
      } else if (Platform.isAndroid) {
        return androidConcursosBanner;
      }
    }
    return BannerAd.testAdUnitId;
  }

  static String getSorteioBannerId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosSorteioBanner;
      } else if (Platform.isAndroid) {
        return androidSorteioBanner;
      }
    }
    return BannerAd.testAdUnitId;
  }

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosSorteioInterstitial;
      } else if (Platform.isAndroid) {
        return androidSorteioInterstitial;
      }
    }
    return InterstitialAd.testAdUnitId;
  }
}
