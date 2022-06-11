import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewsNotificationService {
  //Singleton pattern
  factory NewsNotificationService() {
    return _notificationService;
  }
  NewsNotificationService._internal();
  static final NewsNotificationService _notificationService =
      NewsNotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        // ignore: prefer_const_constructors
        AndroidInitializationSettings('ic_launcher');

    //Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
        // ignore: prefer_const_constructors
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    requestIOSPermissions(flutterLocalNotificationsPlugin);
  }

  void requestIOSPermissions(
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<dynamic> selectNotification(final String payload) async {
    print('Notification was pressed');
    print('Notification payload: $payload');
  }

  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'news_feed_notification_channel_id',
      'News Feed Notification channel name',
      'News Feed Notification channel description',
      importance: Importance.max,
    ),
    iOS: IOSNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound: true,
    ),
  );

  Future<dynamic> showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        12345,
        'A Notification From My Application',
        'This notification was sent using Flutter Local Notifcations Package',
        platformChannelSpecifics,
        payload: 'data');
  }
}
