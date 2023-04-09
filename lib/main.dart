import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
import 'package:provider/provider.dart';
import 'app/ui/views/client_and_appointment_details_view.dart';
import 'package:invoice/app/core/timerModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
        ChangeNotifierProvider(create: (_) => TimerModel()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/admin': (context) => AdminDashboardView(email: '',),
          '/login': (context) => LoginView(),
          '/home': (context) => HomeView(email: '',),
          '/signup': (context) => SignUpView(),
          '/home/addClientDetails': (context) => AddClientDetails(),
          '/home/addBusinessDetails': (context) => AddBusinessDetails(),
          '/admin/assignClients': (context) => AssignClient(),
          '/assignC2E': (context) => AssignC2E(),
          // '/admin/assignClients/timeAndDatePicker': (context) => TimeAndDatePicker(),
        },
      ),
    ),
  );
  if (kDebugMode) {
    // Perform a hot-restart on app start in debug mode
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      debugPrint('Performing hot-restart.');
      debugPrint('--------------------');
      debugPrint('');
      debugPrint('');
      debugPrint('');
      rootBundle.loadString('lib/main.dart').then((code) {
        final uri = Uri.dataFromString(code,
            mimeType: 'application/dart', encoding: Encoding.getByName('utf-8'));
        Isolate.spawnUri(uri, [], null);
      });
    });
  }
}
