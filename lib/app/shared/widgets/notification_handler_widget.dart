import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MoreThanInvoice/notificationservice/local_notification_service.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({super.key, required this.child});

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void onDidReceiveNotification(
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

  @override
  void initState() {
    super.initState();
    initializeNotificationService();
    configureForegroundNotifications();
  }
  //
  // void initializeNotificationService() async {
  //   // Initialization settings for Android
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  //   );
  //
  //   // Initialize the plugin
  //   await _notificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: onDidReceiveNotification,
  //   );
  //
  //   // Create a notification channel
  //   await createNotificationChannel();
  // }

  void initializeNotificationService() async {
    if (Platform.isAndroid) {
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
      await createNotificationChannel();
    }
  }

  Future<dynamic> createAndDisplayNotification(
      int id, String? title, String? body, String? payload) async {
    // Access the LocalNotificationService instance
    final notificationService = LocalNotificationService();

    await notificationService.createAndDisplayNotification(
      id,
      title,
      body,
      payload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  //  void configureForegroundNotifications() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     // Handle foreground notifications here
  //     if (message.notification != null) {
  //       final notificationId = message.data['notificationId'];
  //       final notificationTitle = message.notification!.title;
  //       final notificationBody = message.notification!.body;
  //       final payload = message.data['_id'];
  //
  //       await createAndDisplayNotification(
  //         notificationId,
  //         notificationTitle,
  //         notificationBody,
  //         payload,
  //       );
  //     }
  //   });
  // }

  void configureForegroundNotifications() {
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // Handle foreground notifications here
        if (message.notification != null) {
          final notificationId = message.data['notificationId'];
          final notificationTitle = message.notification!.title;
          final notificationBody = message.notification!.body;
          final payload = message.data['_id'];

          await createAndDisplayNotification(
            notificationId,
            notificationTitle,
            notificationBody,
            payload,
          );
        }
      });
    }
  }

  Future<dynamic> createNotificationChannel() async {
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
