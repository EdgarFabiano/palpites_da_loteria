import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:palpites_da_loteria/defaults/constants.dart';

import 'firebase_options.dart';
import 'widgets/lottery_guesses_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!Constants.isDev) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  MobileAds.instance.initialize();
  runApp(LotteryGuessesApp());
}

