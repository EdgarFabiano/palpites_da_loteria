import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';

class AdMobService {

  static final String androidApiKey = "ca-app-pub-9921693044196842~4393626727";
  static final String androidConcursosBanner = "ca-app-pub-9921693044196842/2888973360";
  static final String androidSorteioInterstitial = "ca-app-pub-9921693044196842/1209850177";

  static final String iosApiKey = "ca-app-pub-9921693044196842~2867650422";
  static final String iosConcursosBanner = "ca-app-pub-9921693044196842/3409548238";
  static final String iosSorteioInterstitial = "ca-app-pub-9921693044196842/3623071156";

  static InterstitialAd _sorteioInterstitial;
  static InterstitialAd get sorteioInterstitial => _sorteioInterstitial;

  static BannerAd _concursosBanner;

  static double _bannerPadding = 0;
  static double get bannerPadding => _bannerPadding;

  static Future<bool> loadConcursosBanner() {
    if (_concursosBanner == null) {
      _concursosBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdMobService.getConcursosBannerId(),
      );
    }
    return _concursosBanner.load();
  }

  static Future<bool> loadSorteioInterstitial() {
    if (_sorteioInterstitial == null) {
      _sorteioInterstitial = InterstitialAd(
        adUnitId: AdMobService.getSorteioInterstitialId(),
      );
    }
    return _sorteioInterstitial.load();
  }

  static void showConcursosBanner() {
    _concursosBanner.isLoaded().then((isLoaded) {
      if (isLoaded) {
        _bannerPadding = 50;
        _concursosBanner.show();
      } else {
        loadConcursosBanner();
        _bannerPadding = 0;
      }
    });
  }

  static void showSorteioInterstitial() {
    _sorteioInterstitial.isLoaded().then((isLoaded) {
      if (isLoaded) {
        _sorteioInterstitial.show();
      } else {
        loadSorteioInterstitial();
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
