import 'package:google_mobile_ads/google_mobile_ads.dart';

class LoteriaBannerAd extends BannerAd {
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  LoteriaBannerAd(
      {required AdSize size,
      required String adUnitId,
      required BannerAdListener listener,
      required AdRequest request})
      : super(
            size: size,
            adUnitId: adUnitId,
            listener: listener,
            request: request);

  @override
  Future<void> load() {
    _isLoaded = true;
    return super.load().onError((error, stackTrace) => _isLoaded = false);
  }

  @override
  Future<void> dispose() {
    _isLoaded = false;
    return super.dispose();
  }
}
