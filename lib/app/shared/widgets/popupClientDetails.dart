import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:flutter/material.dart';

void popUpClientDetails(BuildContext context, String message, String title) {
  if (message == "Success") {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message,
              style: const TextStyle(
                color: AppColors.colorFontPrimary,
                fontWeight: FontWeight.w800,
              )),
          content: Text(
            '$title details added successfully',
            style: const TextStyle(
              color: AppColors.colorFontPrimary,
              height: 1.5,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'Lato',
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK',
                    style: TextStyle(
                        color: AppColors.colorFontSecondary, fontSize: 16)))
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
              )),
          content: Text(
            'Failed or data already added for $title',
            style: const TextStyle(
              color: AppColors.colorFontPrimary,
              height: 1.5,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'Lato',
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK',
                    style: TextStyle(
                        color: AppColors.colorFontSecondary, fontSize: 16)))
          ],
        );
      },
    );
  }
}
