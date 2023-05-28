import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';

import '../model/loteria_banner_ad.dart';

class AdMobService {
  static final String appId = 'ca-app-pub-5932227223136302~3905280679';
  static final String contestsBannerId =
      'ca-app-pub-5932227223136302/6422249913';
  static final String generateGuessBannerId =
      'ca-app-pub-5932227223136302/9648561943';
  static final String mySavedGamesBannerId =
      'ca-app-pub-5932227223136302/8859309599';
  static final String generateGuessInterstitialId =
      'ca-app-pub-5932227223136302/8769211650';
  static final String resultInterstitialId =
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
      createGenerateGuessInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createGenerateGuessInterstitialAd();
    },
  );

  static InterstitialAd? _generateGuessInterstitial;

  static void createGenerateGuessInterstitialAd() {
    if (Constants.showAds) {
      InterstitialAd.load(
          adUnitId: generateGuessInterstitialId,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _generateGuessInterstitial = ad;
              _generateGuessInterstitial!.fullScreenContentCallback =
                  _fullScreenContentCallback;
              _numInterstitialLoadAttempts = 0;
              _generateGuessInterstitial!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _generateGuessInterstitial = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createGenerateGuessInterstitialAd();
              }
            },
          ));
    }
  }

  static void showGenerateGuessInterstitialAd() {
    if (Constants.showAds) {
      if (_generateGuessInterstitial == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }
      _generateGuessInterstitial!.show();
    }
    _generateGuessInterstitial = null;
  }

  static InterstitialAd? _resultInterstitial;

  static void createResultInterstitialAd() {
    if (Constants.showAds) {
      InterstitialAd.load(
          adUnitId: resultInterstitialId,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _resultInterstitial = ad;
              _resultInterstitial!.fullScreenContentCallback =
                  _fullScreenContentCallback;
              _numInterstitialLoadAttempts = 0;
              _resultInterstitial!.setImmersiveMode(true);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _resultInterstitial = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createResultInterstitialAd();
              }
            },
          ));
    }
  }

  static void showResultInterstitialAd() {
    if (Constants.showAds) {
      if (_resultInterstitial == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }

      _resultInterstitial!.show();
    }
    _resultInterstitial = null;
  }
}
