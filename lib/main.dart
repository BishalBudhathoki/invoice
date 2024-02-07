import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:MoreThanInvoice/app/core/view-models/addBusiness_detail_model.dart';
import 'package:MoreThanInvoice/app/core/view-models/addClient_detail_model.dart';
import 'package:MoreThanInvoice/app/core/view-models/forgotPassword_model.dart';
import 'package:MoreThanInvoice/app/ui/views/forgot_password_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/core/view-models/login_model.dart';
import 'package:MoreThanInvoice/app/core/view-models/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/core/view-models/signup_model.dart';
import 'package:MoreThanInvoice/app/ui/shared/themes/app_themes.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/strings/app_strings.dart';
import 'package:MoreThanInvoice/app/ui/views/add_business_details_view.dart';
import 'package:MoreThanInvoice/app/ui/views/add_client_details_view.dart';
import 'package:MoreThanInvoice/app/ui/views/adminDashBoard.dart';
import 'package:MoreThanInvoice/app/ui/views/assignC2E_view.dart';
import 'package:MoreThanInvoice/app/ui/views/assignClient_view.dart';
import 'package:MoreThanInvoice/app/ui/views/home_view.dart';
import 'package:MoreThanInvoice/app/ui/views/login_view.dart';
import 'package:MoreThanInvoice/app/ui/views/photoUpload_view.dart';
import 'package:MoreThanInvoice/app/ui/views/signup_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'app/core/view-models/changePassword_model.dart';
import 'app/core/view-models/sendEmail_model.dart';
import 'package:MoreThanInvoice/app/core/timerModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/ui/views/add_notes_view.dart';
import 'app/ui/views/changePassword_view.dart';
import 'app/ui/views/client_and_appointment_details_view.dart';
import 'app/ui/widgets/navBar_widget.dart';
import 'app/ui/widgets/splashScreen_widget.dart';
import 'backend/shared_preferences_utils.dart';
import 'notificationservice/local_notification_service.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:MoreThanInvoice/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("BGH 1 : ${message.data}");
  print("BGH 2 : ${message.notification?.title}");
}

final mediaStorePlugin = MediaStore();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final notificationPermissionStatus = await Permission.notification.request();
  print('Notification permission status: $notificationPermissionStatus');
  //final internetStatus = await Permission.internet.request();
  // Ask for storage permission
  final storagePermissionStatus = await Permission.storage.request();
  List<Permission> permissions = [
    Permission.storage,
    Permission.manageExternalStorage,
  ];

  // if (Platform.isAndroid) {
  //   if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
  //     permissions.add(Permission.manageExternalStorage);
  //     // permissions.add(Permission.audio);
  //   }
  // }
  //
  // if (storagePermissionStatus.isDenied) {
  //   // Handle denied permission
  //   print('Storage permission is denied.');
  //   await permissions.request();
  //   //return;
  // }
  MediaStore.appFolder = "MediaStorePlugin";
  if (notificationPermissionStatus.isDenied) {
    // Handle denied permission
    print('Notification permission is denied.');
    //return;
  }

  SharedPreferencesUtils prefsUtils = SharedPreferencesUtils();
  await prefsUtils.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider
  //       .debug, // androidProvider: AndroidProvider.safetyNet, // or PlayIntegrity
  //   // appleProvider: AppleProvider.debug
  // );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,
  );

  if (Platform.isAndroid) {
    final notificationService = LocalNotificationService();
    notificationService.initialize();
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
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
        ChangeNotifierProvider(
            create: (_) => PersistentTabController(initialIndex: 0)),
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
        ChangeNotifierProvider(create: (_) => TimerModel()),
        ChangeNotifierProvider(create: (_) => SendEmailModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordModel()),
        ChangeNotifierProvider(create: (_) => AddClientDetailModel()),
        ChangeNotifierProvider(create: (_) => AddBusinessDetailModel()),
        ChangeNotifierProvider<PhotoData>(
          create: (_) => PhotoData(),
          child: PhotoUploadScreen(email: ''),
        ),
        Provider<SharedPreferencesUtils>.value(value: prefsUtils),
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
          '/forgotPassword': (context) => const ForgotPasswordView(),
          '/home/addClientDetails': (context) => const AddClientDetails(),
          '/home/addBusinessDetails': (context) => const AddBusinessDetails(),
          '/admin/assignClients': (context) => const AssignClient(),
          '/assignC2E': (context) => const AssignC2E(),
          '/home/navBar': (context) => NavBarWidget(
                context: context,
                email: 'defaultemail@default.com',
                firstName: 'First Name',
                lastName: 'Last Name',
                role: 'normal',
              ),
          '/home/ClientAndAppointmentDetails': (context) =>
              const ClientAndAppointmentDetails(
                userEmail: '',
                clientEmail: '',
              ),
          '/home/ClientAndAppointmentDetails/addNotes': (context) =>
              const AddNotesView(
                userEmail: '',
                clientEmail: '',
              ),
          '/photoUploadScreen': (context) => PhotoUploadScreen(email: ''),
          '/changePassword': (context) => const ChangePasswordView(),
          // '/admin/assignClients/timeAndDatePicker': (context) => TimeAndDatePicker(),
        },
      ),
    ),
  );
}
