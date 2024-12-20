import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:flutter/material.dart';

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
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
