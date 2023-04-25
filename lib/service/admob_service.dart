import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';

import '../model/loteria_banner_ad.dart';

class AdMobService {
  static final String appId = 'ca-app-pub-5932227223136302~3905280679';
  static final String concursosBannerId =
      'ca-app-pub-5932227223136302/6422249913';
  static final String sorteioBannerId =
      'ca-app-pub-5932227223136302/9648561943';
  static final String meusJogosBannerId =
      'ca-app-pub-5932227223136302/8859309599';
  static final String sorteioInterstitialId =
      'ca-app-pub-5932227223136302/8769211650';
  static final String resultadoInterstitialId =
      'ca-app-pub-5932227223136302/8307560117';

  static const int maxFailedLoadAttempts = 3;
  static int _numInterstitialLoadAttempts = 0;

  static final AdRequest request = AdRequest();

  /*banner*/
  static LotteryBannerAd getBannerAd(String id) {
    LotteryBannerAd banner = LotteryBannerAd(
      adUnitId: id,
      request: AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(onAdLoaded: (Ad ad) {
        print('$ad loaded.');
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('$ad Failed To Load: $error');
        ad.dispose();
      }, onAdOpened: (Ad ad) {
        print('$ad Ad Opened.');
      }, onAdClosed: (Ad ad) {
        print('$ad Ad Closed.');
        ad.dispose();
      }, onAdImpression: (Ad ad) {
        print('$ad Ad Impression.');
      }, onAdClicked: (Ad ad) {
        print('$ad Ad Clicked.');
      }),
      size: AdSize.largeBanner,
    );
    return banner;
  }

  static Widget getBannerAdWidget(LotteryBannerAd bannerAd) {
    if (Constants.showAds && bannerAd.isLoaded) {
      return Container(
        child: AdWidget(ad: bannerAd),
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        alignment: Alignment.center,
      );
    }
    return SizedBox.shrink();
  }

  static var _fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('$ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      createSorteioInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createSorteioInterstitialAd();
    },
  );

  /*sorteio-interstitial*/
  static InterstitialAd? _sorteioInterstitial;

  static void createSorteioInterstitialAd() {
    if (Constants.showAds) {
      InterstitialAd.load(
          adUnitId: sorteioInterstitialId,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _sorteioInterstitial = ad;
              _sorteioInterstitial!.fullScreenContentCallback =
                  _fullScreenContentCallback;
              _numInterstitialLoadAttempts = 0;
              _sorteioInterstitial!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _sorteioInterstitial = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createSorteioInterstitialAd();
              }
            },
          ));
    }
  }

  static void showSorteioInterstitialAd() {
    if (Constants.showAds) {
      if (_sorteioInterstitial == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }
      _sorteioInterstitial!.show();
    }
    _sorteioInterstitial = null;
  }

  /*resultado-interstitial*/
  static InterstitialAd? _resultadoInterstitial;

  static void createResultadoInterstitialAd() {
    if (Constants.showAds) {
      InterstitialAd.load(
          adUnitId: resultadoInterstitialId,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _resultadoInterstitial = ad;
              _resultadoInterstitial!.fullScreenContentCallback =
                  _fullScreenContentCallback;
              _numInterstitialLoadAttempts = 0;
              _resultadoInterstitial!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _resultadoInterstitial = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createResultadoInterstitialAd();
              }
            },
          ));
    }
  }

  static void showResultadoInterstitialAd() {
    if (Constants.showAds) {
      if (_resultadoInterstitial == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }

      _resultadoInterstitial!.show();
    }
    _resultadoInterstitial = null;
  }
}
