import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  // Pedir permisos
  static Future<void> requesPermissionLocalNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Inicializar las localNotifications
  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //inicializacion para android
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    //TODO iOS configuration

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      //TODO iOS configurationsettings
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // TODO
      //onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // Mostrar las localNotofocations
  static void showLocalNotifications({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      //TODO iOS
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: data,
    );
  }
}
