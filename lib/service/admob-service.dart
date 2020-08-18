import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';

class AdMobService {

  static final String androidApiKey = "ca-app-pub-9921693044196842~4393626727";
  static final String androidConcursosBanner = "ca-app-pub-9921693044196842/2888973360";
  static final String androidSorteioInterstitial = "ca-app-pub-9921693044196842/1209850177";

  static final String iosApiKey = "ca-app-pub-9921693044196842~2867650422";
  static final String iosConcursosBanner = "ca-app-pub-9921693044196842/3409548238";
  static final String iosSorteioInterstitial = "ca-app-pub-9921693044196842/3623071156";

  static AdmobInterstitial _sorteioInterstitial;
  static AdmobInterstitial get sorteioInterstitial => _sorteioInterstitial;

  static AdmobBanner _concursosBanner;

  static AdmobBanner getConcursosBanner() {
    if (_concursosBanner == null) {
      _concursosBanner = AdmobBanner(
        adSize: AdmobBannerSize.FULL_BANNER,
        adUnitId: AdMobService.getConcursosBannerId(),
      );
    }
    return _concursosBanner;
  }

  static AdmobInterstitial  getSorteioInterstitial() {
    if (_sorteioInterstitial == null) {
      _sorteioInterstitial = AdmobInterstitial (
        adUnitId: AdMobService.getSorteioInterstitialId(),
      );
    }
    return _sorteioInterstitial;
  }

  static void showSorteioInterstitial() {
    _sorteioInterstitial.isLoaded.then((isLoaded) {
      if (isLoaded) {
        _sorteioInterstitial.show();
      } else {
        getSorteioInterstitial();
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

  static double getBannerSize(BuildContext context) {
    return 60;
  }
}
