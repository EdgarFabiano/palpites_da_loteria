import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';

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

  static final String appId = Platform.isAndroid
      ? "ca-app-pub-9921693044196842~4393626727"
      : "ca-app-pub-9921693044196842~2867650422";

  static String getAppId() {
    if (!Constants.isTesting) {
      return appId;
    }
    return testAppId;
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

  /*concursos-banner*/
  static final String concursosBannerId = Platform.isAndroid
      ? "ca-app-pub-9921693044196842/2888973360"
      : "ca-app-pub-9921693044196842/3409548238";

  static BannerAd _concursosBanner;

  static String getConcursosBannerId() {
    if (!Constants.isTesting) {
      return concursosBannerId;
    }
    return bannerTestAdUnitId;
  }

  static BannerAd startConcursosBanner() {
    if (_concursosBanner == null) {
      _concursosBanner = BannerAd(
        adUnitId: getConcursosBannerId(),
        size: AdSize.smartBanner,
      );
    }
    return _concursosBanner;
  }

  static void displayConcursosBanner() {
    _concursosBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  /*sorteio-interstitial*/
  static final String sorteioInterstitialId = Platform.isAndroid
      ? "ca-app-pub-9921693044196842/1209850177"
      : "ca-app-pub-9921693044196842/3623071156";

  static InterstitialAd _sorteioInterstitial;

  static InterstitialAd get sorteioInterstitial => _sorteioInterstitial;

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      return sorteioInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

  static InterstitialAd buildSorteioInterstitial() {
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

  /*resultado-interstitial*/
  static final String resultadoInterstitialId = Platform.isAndroid
      ? "ca-app-pub-9921693044196842/3747778987"
      : "ca-app-pub-9921693044196842/7495452301";

  static InterstitialAd _resultadoInterstitial;

  static InterstitialAd get resultadoInterstitial => _resultadoInterstitial;

  static String getResultadoInterstitialId() {
    if (!Constants.isTesting) {
      return resultadoInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

  static InterstitialAd buildResultadoInterstitial() {
    return InterstitialAd(
        adUnitId: getResultadoInterstitialId(),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _resultadoInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            _resultadoInterstitial.dispose();
          }
        });
  }

}
