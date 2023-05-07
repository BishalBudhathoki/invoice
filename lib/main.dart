import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
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
import 'package:invoice/app/ui/views/signup_view.dart';
import 'package:invoice/app/ui/views/timeAndDatePicker_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'app/core/view-models/sendEmail_model.dart';
import 'app/ui/views/client_and_appointment_details_view.dart';
import 'package:invoice/app/core/timerModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  print(dotenv.env['EMAIL_ADDRESS']);
  print(dotenv.env['EMAIL_PASSWORD']);
  print(dotenv.env['RECIPIENT_EMAIL_ADDRESS']);
  // Ask for storage permission
  final status = await Permission.storage.request();
  //final internetStatus = await Permission.internet.request();
  if (status.isDenied ) {
    // Handle denied permission
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
        ChangeNotifierProvider(create: (_) => TimerModel()),
        ChangeNotifierProvider(create: (_) => SendEmailModel()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/admin': (context) => const AdminDashboardView(
                email: '',
              ),
          '/login': (context) => const LoginView(),
          '/home': (context) => const HomeView(
                email: '',
              ),
          '/signup': (context) => const SignUpView(),
          '/home/addClientDetails': (context) => const AddClientDetails(),
          '/home/addBusinessDetails': (context) => const AddBusinessDetails(),
          '/admin/assignClients': (context) => const AssignClient(),
          '/assignC2E': (context) => AssignC2E(),
          // '/admin/assignClients/timeAndDatePicker': (context) => TimeAndDatePicker(),
        },
      ),
    ),
  );
  if (kDebugMode) {
    // Perform a hot-restart on app start in debug mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Performing hot-restart.');
      debugPrint('--------------------');
      debugPrint('');
      debugPrint('');
      debugPrint('');
      rootBundle.loadString('lib/main.dart').then((code) {
        final uri = Uri.dataFromString(code,
            mimeType: 'application/dart',
            encoding: Encoding.getByName('utf-8'));
        Isolate.spawnUri(uri, [], null);
      });
    });
  }
}
