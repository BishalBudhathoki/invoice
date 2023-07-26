import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialization settings for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );

    // Create a notification channel
    await _createNotificationChannel();
  }

  Future<void> createAndDisplayNotification(
      int id, String? title, String? body, String? payload) async {
    // Create a notification
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'invoicechannel',
      'invoicechannel',
      importance: Importance.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    // Handle notification tap
    print('Notification tapped with payload: ${notificationResponse.payload}');
    if (notificationResponse.payload != null) {
      // Parse the payload and handle accordingly
      // Example: {"notificationId": 123, "actionId": "action_1"}
      final parsedPayload =
          notificationResponse.payload as Map<String, dynamic>;
      final notificationId = parsedPayload['notificationId'];
      final notificationTitle = parsedPayload['notificationTitle'];
      final notificationBody = parsedPayload['notificationBody'];
      final actionId = parsedPayload['actionId'];
      // Display a notification
      await createAndDisplayNotification(
        notificationId,
        notificationTitle,
        notificationBody,
        parsedPayload as String?,
      );
    }
  }

  Future<void> _createNotificationChannel() async {
    print("create notification channel");
    // Create a notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'invoicechannel',
      'invoicechannel',
      importance: Importance.high,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
