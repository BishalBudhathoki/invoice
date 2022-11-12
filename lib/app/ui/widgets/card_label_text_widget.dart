import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class CardLabelTextWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String text;

  const CardLabelTextWidget(this.iconData, this.label, this.text,
      {Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: AppColors.colorPrimary,
          size: 35,
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Text(
                label,
                style: const TextStyle(
                  color: AppColors.colorFontPrimary,
                  fontSize: AppDimens.fontSizeMedium,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Loto',
                )),
            const SizedBox(
              width: 05,
            ),
            Text(
                text,
                style: const TextStyle(
                  color: AppColors.colorFontPrimary,
                  fontSize: AppDimens.fontSizeMedium,
                  fontFamily: 'Lato',
                  //fontWeight: FontWeight.w900,
                )),
          ],
        ),
      ],
    );
  }
}