import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'defaults/constants.dart';
import 'firebase_options.dart';
import 'widgets/palpites_loteria_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!Constants.isTesting) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  setRemoteConfigDefaults();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  MobileAds.instance.initialize();
  runApp(PalpitesLoteriaApp());
}

setRemoteConfigDefaults() {
  FirebaseRemoteConfig.instance.setDefaults(const {
    "privacy_policy_url":
        "https://play.google.com/store/apps/datasafety?id=com.efs.palpites_da_loteria2",
    "use_terms_url": "https://www.iubenda.com/privacy-policy/53831292",
  });
}
