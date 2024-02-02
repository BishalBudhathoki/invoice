import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/dimens/app_dimens.dart';

class CardLabelTextWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String text;

  const CardLabelTextWidget(this.iconData, this.label, this.text, {super.key});

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
        Flexible(
          child: Row(
            children: [
              Text(label,
                  style: const TextStyle(
                    color: AppColors.colorFontPrimary,
                    fontSize: AppDimens.fontSizeMedium,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Loto',
                  )),
              const SizedBox(
                width: 05,
              ),
              Flexible(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.colorFontPrimary,
                      fontSize: AppDimens.fontSizeMedium,
                      fontFamily: 'Lato',
                      //fontWeight: FontWeight.w900,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
