
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';

class AdMobService {
  static final String testAppId = 'ca-app-pub-3940256099942544~3347511713';
  static final String bannerTestAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static final String interstitialTestAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static final String appId = 'ca-app-pub-5932227223136302~5495066076';

  static const int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest();

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
  Constants.isTesting ? bannerTestAdUnitId :
  'ca-app-pub-5932227223136302/9652914887';

  static final String sorteioBannerId =
  Constants.isTesting ? bannerTestAdUnitId :
  'ca-app-pub-5932227223136302/6252940206';

  static BannerAd getBannerAd(String id) {
    BannerAd banner = BannerAd(
        adUnitId: id,
        request: AdManagerAdRequest(),
        listener: AdManagerBannerAdListener(
          onAdLoaded: (Ad ad) {
            print('$ad loaded.');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$ad Failed To Load: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$ad Ad Opened.'),
          onAdClosed: (Ad ad) {
            print('$ad Ad Closed.');
            ad.dispose();
            },
        ), size: AdSize.largeBanner,
      );

    return banner;
  }

  static Widget getBannerAdWidget (BannerAd bannerAd) {
    return Container(
      child: AdWidget(ad: bannerAd),
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      alignment: Alignment.center,
    );
  }


  /*sorteio-interstitial*/
  static final String sorteioInterstitialId =
      'ca-app-pub-5932227223136302/1351753033';

  static InterstitialAd? _sorteioInterstitial;

  static InterstitialAd? get sorteioInterstitial => _sorteioInterstitial;

  static int _numInterstitialLoadAttempts = 0;

  static String getSorteioInterstitialId() {
    if (!Constants.isTesting) {
      return sorteioInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

  static void createSorteioInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getSorteioInterstitialId(),
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _sorteioInterstitial = ad;
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

  static void showSorteioInterstitialAd() {
    if (_sorteioInterstitial == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _sorteioInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
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
    _sorteioInterstitial!.show();
    _sorteioInterstitial = null;
  }

  /*resultado-interstitial*/
  static final String resultadoInterstitialId =
      'ca-app-pub-5932227223136302/4509287460';

  static InterstitialAd? _resultadoInterstitial;

  static InterstitialAd? get resultadoInterstitial => _resultadoInterstitial;

  static String getResultadoInterstitialId() {
    if (!Constants.isTesting) {
      return resultadoInterstitialId;
    }
    return interstitialTestAdUnitId;
  }

  static void createResultadoInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getResultadoInterstitialId(),
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _resultadoInterstitial = ad;
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

  static void showResultadoInterstitialAd() {
    if (_resultadoInterstitial == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _resultadoInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createResultadoInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createResultadoInterstitialAd();
      },
    );
    _resultadoInterstitial!.show();
    _resultadoInterstitial = null;
  }

}
