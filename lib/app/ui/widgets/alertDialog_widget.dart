import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Container(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.colorFontPrimary),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Checking details...",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.colorFontPrimary,
                fontSize: AppDimens.fontSizeXXMedium,
                fontWeight: FontWeight.w800,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
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
