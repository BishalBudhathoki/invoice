import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';

import '../values/dimens/app_dimens.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
      primaryColor: AppColors.colorPrimary,
      primaryColorDark: AppColors.colorPrimaryDark,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.colorPrimary,
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light),
      textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.colorFontPrimary,
            fontSize: AppDimens.fontSizeMedium,
            fontWeight: FontWeight.w900,
            fontFamily: 'Lato',
          ),
          bodyMedium: TextStyle(
            color: AppColors.colorFontPrimary,
            fontSize: AppDimens.fontSizeNormal,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lato',
          ),
          labelLarge: TextStyle(
            color: AppColors.colorPrimary,
            fontSize: AppDimens.fontSizeXXXMedium,
            fontWeight: FontWeight.w900,
            fontFamily: 'Lato',
          ),
          titleMedium: TextStyle(
            color: AppColors.colorWhite,
            fontSize: AppDimens.fontSizeMedium,
            fontWeight: FontWeight.w900,
            fontFamily: 'Lato',
          ),
          ),

      colorScheme: ThemeData().colorScheme.copyWith(
          secondary: AppColors.colorAccent,
          primary: AppColors.colorPrimary,
          onPrimary: AppColors.colorPrimary));
}
