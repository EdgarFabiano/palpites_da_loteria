import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/pages/home_page.dart';
import 'package:palpites_da_loteria/widgets/contests_settings_change_notifier.dart';
import 'package:provider/provider.dart';

import '../model/contest.dart';
import '../service/contest_service.dart';

class LotteryGuessesApp extends StatelessWidget {
  final ContestService _contestService = ContestService();
  final ContestsSettingsChangeNotifier contestsSettingsChangeNotifier =
  ContestsSettingsChangeNotifier();

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
