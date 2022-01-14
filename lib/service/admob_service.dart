
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';

class AdMobService {
  static final String testAppId = 'ca-app-pub-3940256099942544~3347511713';
  static final String bannerTestAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static final String interstitialTestAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static final String appId = 'ca-app-pub-5932227223136302~5495066076';

  static List<String> testDevices() {
    return ['4B0FDC40963AB3E77AED679FF240F802',
      '118F4E581E0D5DAA4F78D3B1A29E861C'];
  }

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
  static final String concursosBannerId =
      'ca-app-pub-5932227223136302/9652914887';

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
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _concursosBanner?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            _concursosBanner?.load();
          }
        },
        targetingInfo: MobileAdTargetingInfo(
            testDevices: testDevices()),
      );
    }
    return _concursosBanner;
  }

  /*sorteio-interstitial*/
  static final String sorteioInterstitialId =
      'ca-app-pub-5932227223136302/1351753033';

  static InterstitialAd _sorteioInterstitial;

  static InterstitialAd get sorteioInterstitial => _sorteioInterstitial;

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      return sorteioInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

  static InterstitialAd buildSorteioInterstitial() {
    _sorteioInterstitial = InterstitialAd(
        adUnitId: getSorteioInterstitialId(),
        targetingInfo: MobileAdTargetingInfo(
            testDevices: testDevices()),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _sorteioInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked ||
              event == MobileAdEvent.closed ||
              event == MobileAdEvent.impression ||
              event == MobileAdEvent.leftApplication) {
            _sorteioInterstitial?.dispose();
            _sorteioInterstitial = null;
          }
        });
    return _sorteioInterstitial;
  }

  /*resultado-interstitial*/
  static final String resultadoInterstitialId =
      'ca-app-pub-5932227223136302/4509287460';

  static InterstitialAd _resultadoInterstitial;

  static InterstitialAd get resultadoInterstitial => _resultadoInterstitial;

  static String getResultadoInterstitialId() {
    if (!Constants.isTesting) {
      return resultadoInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

}
