import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String groupKey = 'com.efs.palpites_da_loteria';
  final String groupChannelId = 'Palpites da loteria';
  final String groupChannelName = 'Resultados dos concursos';
  final String groupChannelDescription = 'Notificações do aplicativo Palpites da loteria';

  NotificationService._privateConstructor() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("America/Sao_Paulo"));
    initializeLocalNotifications();
  }

  Future initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo_notifications');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotifications() async {
    final List<ActiveNotification> activeNotifications =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        activeNotifications.map((e) => e.title).toList(),
        contentTitle: 'Palpites da loteria',
        summaryText: 'Resultados dos concursos');

    NotificationScheduler.configureSummary(inboxStyleInformation);
    NotificationScheduler.configureMegaSena(inboxStyleInformation);
    NotificationScheduler.configureLotofacil(inboxStyleInformation);
    NotificationScheduler.configureQuina(inboxStyleInformation);
    NotificationScheduler.configureLotomania(inboxStyleInformation);
    NotificationScheduler.configureTimemania(inboxStyleInformation);
    NotificationScheduler.configureDuplasena(inboxStyleInformation);
    NotificationScheduler.configureDiaDeSorte(inboxStyleInformation);

  }

  static final NotificationService _instance =
      NotificationService._privateConstructor();

  factory NotificationService() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

}
