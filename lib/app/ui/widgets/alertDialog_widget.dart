import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        SizedBox(
          width: context.width * 0.65,
          child: Row(
            children: const [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorFontPrimary),
              ),
              Text("    Checking details ...",
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
                    fontSize: AppDimens.fontSizeLarge,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Lato',
                  )
              ),
            ]
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
