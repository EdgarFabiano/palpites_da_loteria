

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:palpites_da_loteria/defaults/defaults_export.dart';
import 'package:palpites_da_loteria/service/notification_service.dart';

class NotificationScheduler {
  static var notificationService = NotificationService();

  static var defaultTime = Time(19, 48, 00);

  static var megaSenaSorteios = [Day.wednesday, Day.saturday, Day.sunday];
  static var lotofacilSorteios = [Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday, Day.saturday, Day.sunday];
  static var quinaSorteios = [Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday, Day.saturday, Day.sunday];
  static var lotomaniaSorteios = [Day.tuesday, Day.friday, Day.sunday];
  static var timeManiaSorteios = [Day.tuesday, Day.thursday, Day.saturday, Day.sunday];
  static var duplaSenaSorteios = [Day.tuesday, Day.thursday, Day.saturday, Day.sunday];
  static var diaDeSorteSorteios = [Day.tuesday, Day.thursday, Day.saturday, Day.sunday];
  static var summarySorteios = [Day.monday, Day.tuesday, Day.wednesday, Day.thursday, Day.friday, Day.saturday, Day.sunday];

  static Future configureMegaSena(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails megaSenaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Mega-sena', 'Mega-sena', 'Notificações sobre o concurso da Mega-sena',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_megasena",
        showWhen: true);

    megaSenaSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Mega-sena! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: megaSenaAndroidNotificationDetails));
    });

  }

  static Future configureLotofacil(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails lotoFacilAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Lotofácil', 'Lotofácil', 'Notificações sobre o concurso da Lotofácil',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_lotofacil",
        showWhen: true);

    lotofacilSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Lotofácil! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: lotoFacilAndroidNotificationDetails));
    });

  }

  static Future configureQuina(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails quinaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Quina', 'Quina', 'Notificações sobre o concurso da Quina',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_quina",
        showWhen: true);

    quinaSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Quina! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: quinaAndroidNotificationDetails));
    });

  }

  static Future configureLotomania(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails lotomaniaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Lotomania', 'Lotomania', 'Notificações sobre o concurso da Lotomania',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_lotomania",
        showWhen: true);

    lotomaniaSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Lotomania! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: lotomaniaAndroidNotificationDetails));
    });

  }

  static Future configureTimemania(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails timemaniaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Timemania', 'Timemania', 'Notificações sobre o concurso da Timemania',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_timemania",
        showWhen: true);

    timeManiaSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Timemania! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: timemaniaAndroidNotificationDetails));
    });

  }

  static Future configureDuplasena(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails duplaSenaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Dupla-sena', 'Dupla-sena', 'Notificações sobre o concurso da Dupla-sena',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_duplasena",
        showWhen: true);

    duplaSenaSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Dupla-sena! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: duplaSenaAndroidNotificationDetails));
    });

  }

  static Future configureDiaDeSorte(InboxStyleInformation inboxStyleInformation) async {
    AndroidNotificationDetails diaDeSorteSenaAndroidNotificationDetails =
    AndroidNotificationDetails(
        'Dia de sorte', 'Dia de sorte', 'Notificações sobre o concurso da Dia de sorte',
        styleInformation: inboxStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: notificationService.groupKey,
        icon: "notification_diadesorte",
        showWhen: true);

    diaDeSorteSorteios.forEach((day) async {
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(1,
          'Dia de sorte! Resultado disponível',
          Strings.randomNotificationBody(),
          day,
          defaultTime,
          NotificationDetails(android: diaDeSorteSenaAndroidNotificationDetails));
    });

  }

  static Future configureSummary(InboxStyleInformation inboxStyleInformation) async {
    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        notificationService.groupChannelId,
        notificationService.groupChannelName,
        notificationService.groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: notificationService.groupKey,
        setAsGroupSummary: true);

    summarySorteios.forEach((day) async {
      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await notificationService.flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(100,
          'Atenção', 'Resultados disponíveis',
          day,
          defaultTime,
          platformChannelSpecifics);
    });

  }

}