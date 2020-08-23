import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';

class AdMobService {

  static final String testAppId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';

  static final String bannerTestAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static final String interstitialTestAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static final String androidApiKey = "ca-app-pub-9921693044196842~4393626727";
  static final String androidConcursosBanner = "ca-app-pub-9921693044196842/2888973360";
  static final String androidSorteioInterstitial = "ca-app-pub-9921693044196842/1209850177";

  static final String iosApiKey = "ca-app-pub-9921693044196842~2867650422";
  static final String iosConcursosBanner = "ca-app-pub-9921693044196842/3409548238";
  static final String iosSorteioInterstitial = "ca-app-pub-9921693044196842/3623071156";

  static InterstitialAd _sorteioInterstitial;
  static InterstitialAd get sorteioInterstitial => _sorteioInterstitial;

  static BannerAd _concursosBanner;

  static BannerAd startConcursosBanner() {
    if (_concursosBanner == null) {
      _concursosBanner = BannerAd(
        adUnitId: getConcursosBannerId(),
        size: AdSize.smartBanner,
      );
    }
    return _concursosBanner;
  }

  static void displayBanner() {
    _concursosBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  static InterstitialAd buildInterstitial() {
    return InterstitialAd(
        adUnitId: getSorteioInterstitialId(),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _sorteioInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            _sorteioInterstitial.dispose();
          }
        });
  }

  static String getAppId() {
    if (Platform.isIOS) {
      return iosApiKey;
    } else if (Platform.isAndroid) {
      return androidApiKey;
    }
    return testAppId;
  }

  static String getConcursosBannerId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosConcursosBanner;
      } else if (Platform.isAndroid) {
        return androidConcursosBanner;
      }
    }
    return bannerTestAdUnitId;
  }

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      if (Platform.isIOS) {
        return iosSorteioInterstitial;
      } else if (Platform.isAndroid) {
        return androidSorteioInterstitial;
      }
    }
    return interstitialTestAdUnitId;
  }

  static double bannerPadding(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    if (height <= 400) {
      return 32;
    } else if (height >= 720) {
      return 90;
    }
    return 50;
  }

}
