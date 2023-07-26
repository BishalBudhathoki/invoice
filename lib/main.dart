import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:invoice/app/ui/widgets/notification_handler_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/app/core/view-models/signup_model.dart';
import 'package:invoice/app/ui/shared/themes/app_themes.dart';
import 'package:invoice/app/ui/shared/values/strings/app_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/adminDashBoard.dart';
import 'package:invoice/app/ui/views/assignC2E_view.dart';
import 'package:invoice/app/ui/views/assignClient_view.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/views/login_view.dart';
import 'package:invoice/app/ui/views/photoUpload_view.dart';
import 'package:invoice/app/ui/views/signup_view.dart';
import 'package:invoice/app/ui/views/timeAndDatePicker_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'app/core/view-models/sendEmail_model.dart';
import 'app/ui/views/client_and_appointment_details_view.dart';
import 'package:invoice/app/core/timerModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/ui/widgets/splashScreen_widget.dart';
import 'firebase_options.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("BGH 1 : ${message.data}");
  print("BGH 2 : ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // Ask for storage permission
  final storagePermissionStatus = await Permission.storage.request();
  final notificationPermissionStatus = await Permission.notification.request();
  print('Notification permission status: $notificationPermissionStatus');
  //final internetStatus = await Permission.internet.request();
  if (storagePermissionStatus.isDenied) {
    // Handle denied permission
    print('Storage permission is denied.');
    return;
  }
  if (notificationPermissionStatus.isDenied) {
    // Handle denied permission
    print('Notification permission is denied.');
    return;
  }
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    final notificationService = LocalNotificationService();
    notificationService.initialize();
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: ${fcmToken}");
    // Configure the notification handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Fore ground Messaging here::");
      print("FirebaseMessaging.onMessage");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data11 ${message.data}");
        notificationService.createAndDisplayNotification(
            message.data['_id'],
            message.notification!.title,
            message.notification!.body,
            message.data['_id']);
      }
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
        ChangeNotifierProvider(create: (_) => TimerModel()),
        ChangeNotifierProvider(create: (_) => SendEmailModel()),
        ChangeNotifierProvider<PhotoData>(
          create: (_) => PhotoData(),
          child: PhotoUploadScreen(email: ''),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashScreen',
        routes: {
          '/splashScreen': (context) => const SplashScreen(),
          '/admin': (context) => const AdminDashboardView(email: ''),
          '/login': (context) => const LoginView(),
          '/home': (context) => const HomeView(email: ''),
          '/signup': (context) => const SignUpView(),
          '/home/addClientDetails': (context) => const AddClientDetails(),
          '/home/addBusinessDetails': (context) => const AddBusinessDetails(),
          '/admin/assignClients': (context) => const AssignClient(),
          '/assignC2E': (context) => AssignC2E(),
          '/photoUploadScreen': (context) => PhotoUploadScreen(email: ''),
          // '/admin/assignClients/timeAndDatePicker': (context) => TimeAndDatePicker(),
        },
      ),
    ),
  );
}
