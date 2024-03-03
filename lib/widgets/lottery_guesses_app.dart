import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/model/device_info.dart';
import 'package:palpites_da_loteria/pages/home_page.dart';
import 'package:palpites_da_loteria/service/lottery_api_service.dart';
import 'package:palpites_da_loteria/widgets/contests_settings_change_notifier.dart';
import 'package:provider/provider.dart';

import '../model/contest.dart';
import '../service/contest_service.dart';

class LotteryGuessesApp extends StatelessWidget {
  final ContestService _contestService = ContestService();
  final ContestsSettingsChangeNotifier contestsSettingsChangeNotifier =
  ContestsSettingsChangeNotifier();

  Future<String> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return "";
  }

  String _getDevicePlatform() => Platform.isAndroid ? "a" : "i";

  Future<void> _saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      userId = userCredential.user?.uid;
    }

    LotteryAPIService().registerDevice(DeviceInfo(
        registrationId: token,
        userId: userId,
        devicePlatform: _getDevicePlatform(),
        deviceHardwareId: await _getDeviceId(),
        applicationId: "com.efs.palpites_da_loteria2"));
  }

  Future<void> _setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await _saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenToDatabase);
  }

  Future<void> _initContests() async {
    contestsSettingsChangeNotifier.contests = await _contestService.initContests();
  }

  @override
  Widget build(BuildContext context) {
    _initContests();
    _createNotificationChannels();

    //No need to store token anywhere, just topics subscription for now
    //_setupToken();

    return EasyDynamicThemeWidget(
      child: MultiProvider(
        child: ContestsMaterialApp(),
        providers: [
          ChangeNotifierProvider<ContestsSettingsChangeNotifier>(
            create: (_) => contestsSettingsChangeNotifier,
          ),
        ],
      ),
    );
  }

  Future<void> _createNotificationChannels() async {
    List<Contest> contests = await _contestService.initContests();
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      AndroidNotificationChannel? channel;
      contests.forEach((element) {
        channel = AndroidNotificationChannel(
          element.getEndpoint(),
          element.name,
          description:
              'Este canal é utilizado para notificações dos concursos da ${element.name}.',
          importance: Importance.high,
        );

        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);
        element.updateTopicSubscription();
      });
    }
  }
}

class ContestsMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: DefaultThemes.appTheme(),
      darkTheme: DefaultThemes.darkTheme(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
