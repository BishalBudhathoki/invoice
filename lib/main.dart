import 'dart:io';
import 'package:MoreThanInvoice/app/features/auth/models/user_role.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/verify_otp_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:MoreThanInvoice/app/features/busineess/models/addBusiness_detail_model.dart';
import 'package:MoreThanInvoice/app/features/client/models/addClient_detail_model.dart';
import 'package:MoreThanInvoice/app/features/auth/models/forgotPassword_model.dart';
import 'package:MoreThanInvoice/app/features/auth/views/forgot_password_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/auth/models/login_model.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/features/auth/models/signup_model.dart';
import 'package:MoreThanInvoice/app/features/busineess/views/add_business_details_view.dart';
import 'package:MoreThanInvoice/app/features/client/views/add_client_details_view.dart';
import 'package:MoreThanInvoice/app/features/admin/views/admin_dashboard_view.dart';
import 'package:MoreThanInvoice/app/features/Appointment/views/assignC2E_view.dart';
import 'package:MoreThanInvoice/app/features/Appointment/views/assignClient_view.dart';
import 'package:MoreThanInvoice/app/features/home/views/home_view.dart';
import 'package:MoreThanInvoice/app/features/auth/views/login_view.dart';
import 'package:MoreThanInvoice/app/features/photo/views/photo_upload_view.dart';
import 'package:MoreThanInvoice/app/features/auth/views/signup_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'app/features/auth/models/changePassword_model.dart';
import 'app/features/auth/viewmodels/change_password_viewmodel.dart';
import 'app/features/auth/viewmodels/forgot_password_viewmodel.dart';
import 'app/features/auth/viewmodels/login_viewmodel.dart';
import 'app/features/auth/viewmodels/signup_viewmodel.dart';
import 'app/features/invoice/viewmodels/invoice_email_viewmodel.dart';
import 'package:MoreThanInvoice/app/core/services/timer_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/features/notes/views/add_notes_view.dart';
import 'app/features/auth/views/change_password_view.dart';
import 'app/features/Appointment/views/client_appointment_details_view.dart';
import 'app/shared/constants/themes/app_themes.dart';
import 'app/shared/constants/values/strings/app_strings.dart';
import 'app/shared/widgets/navBar_widget.dart';
import 'app/shared/utils/shared_preferences_utils.dart';
import 'app/shared/widgets/splashScreen_widget.dart';
import 'notificationservice/local_notification_service.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:MoreThanInvoice/firebase_options.dart';
import 'package:MoreThanInvoice/app/di/service_locator.dart'; // Import the service locator
import 'app/features/busineess/viewmodels/add_business_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/auth/models/visibility_toggle_model_impl.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("BGH 1 : ${message.data}");
  print("BGH 2 : ${message.notification?.title}");
}

final mediaStorePlugin = MediaStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setupLocator(); // Set up the service locator

  await _requestPermissions();
  await _initializeFirebase();
  await _initializeAppCheck();

  // Initialize SharedPreferencesUtils and get the role
  SharedPreferencesUtils prefsUtils = SharedPreferencesUtils();
  await prefsUtils.init();
  UserRole role = await prefsUtils.getRole() ??
      UserRole.normal; // Default to UserRole.normal if null

  runApp(MyApp(role));
}

Future<void> _requestPermissions() async {
  final notificationPermissionStatus = await Permission.notification.request();
  print('Notification permission status: $notificationPermissionStatus');

  final storagePermissionStatus = await Permission.storage.request();
  if (storagePermissionStatus.isDenied) {
    print('Storage permission is denied.');
    await [Permission.storage, Permission.manageExternalStorage].request();
  }

  MediaStore.appFolder = "MediaStorePlugin";
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isAndroid) {
    final notificationService = LocalNotificationService();
    notificationService.initialize();
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Messaging here::");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        notificationService.createAndDisplayNotification(
          message.data['_id'],
          message.notification!.title,
          message.notification!.body,
          message.data['_id'],
        );
      }
    });
  }
}

Future<void> _initializeAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
}

class MyApp extends StatelessWidget {
  final UserRole role;

  MyApp(this.role);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PersistentTabController(initialIndex: 0)),
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
        ChangeNotifierProvider(create: (_) => VisibilityToggleModelImpl()),
        ChangeNotifierProvider(create: (_) => TimerService()),
        ChangeNotifierProvider(create: (_) => InvoiceEmailViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => VerifyOTPViewModel()),
        ChangeNotifierProvider(create: (_) => AddClientDetailModel()),
        ChangeNotifierProvider(create: (_) => AddBusinessDetailModel()),
        ChangeNotifierProvider(create: (_) => AddBusinessViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider<PhotoData>(create: (_) => PhotoData()),
        Provider<SharedPreferencesUtils>(
            create: (_) => SharedPreferencesUtils()..init()),
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
                role: role,
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
        },
      ),
    );
  }
}
