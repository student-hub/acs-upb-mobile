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

  //static final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        // ignore: prefer_const_constructors
        AndroidInitializationSettings('app_icon');

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
  }

  // void requestIOSPermissions(
  //     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  Future<dynamic> selectNotification(final String payload) async {
    print('Notification was pressed');
    print('Notification payload: $payload');
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  // static Future<dynamic> _notificationDetails() async {
  //   return const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'news_feed_notification_channel_id',
  //       'News Feed Notification channel name',
  //       'News Feed Notification channel description',
  //       importance: Importance.max,
  //     ),
  //     iOS: IOSNotificationDetails(),
  //   );
  // }

  // static Future<dynamic> showNotification({
  //   final int id = 0,
  //   final String title,
  //   final String body,
  //   final String payload,
  // }) async =>
  //     _notifications.show(
  //       id,
  //       title,
  //       body,
  //       await _notificationDetails(),
  //       payload: payload,
  //     );
}
