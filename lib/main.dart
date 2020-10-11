
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/palpites_da_loteria_app.dart';
import 'package:palpites_da_loteria/service/notification_service.dart';

import 'service/admob_service.dart';

void main() {
  initializeFirebase();
  NotificationService().scheduleNotifications();
  runApp(PalpitesLoteriaApp());
}

void initializeFirebase() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdMobService.getAppId());
}
