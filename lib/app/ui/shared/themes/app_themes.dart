import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
      primaryColor: AppColors.colorPrimary,
      primaryColorDark: AppColors.colorPrimaryDark,
      brightness: Brightness.light,

      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.colorPrimary, iconTheme: IconThemeData(color: Colors.white), systemOverlayStyle: SystemUiOverlayStyle.light),
      colorScheme:
      ThemeData().colorScheme.copyWith(secondary: AppColors.colorAccent, primary: AppColors.colorPrimary, onPrimary: AppColors.colorPrimary));
}