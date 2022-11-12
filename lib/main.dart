import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/core/view-models/signup_model.dart';
import 'package:invoice/app/routes/app_pages.dart';
import 'package:invoice/app/ui/shared/themes/app_themes.dart';
import 'package:invoice/app/ui/shared/values/strings/app_strings.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/views/login_view.dart';
import 'package:invoice/app/ui/views/signup_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginModel()),
        ChangeNotifierProvider(create: (_) => SignupModel()),
      ],

      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/home': (context) => HomeView(email: '',),
          '/signup': (context) => SignUpView(),
        },
      ),
    ),
  );
}
