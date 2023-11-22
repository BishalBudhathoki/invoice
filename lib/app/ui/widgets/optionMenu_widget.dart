import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class OptionMenuWidget extends StatelessWidget {
  final String iconName;
  final IconData iconSax;
  final VoidCallback onPressed;

  const OptionMenuWidget({
    super.key,
    required this.iconName,
    required this.iconSax,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(
                iconSax,
                color: AppColors.colorPrimary,
                size: 35,
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text('Home',
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
                    fontSize: AppDimens.fontSizeMedium,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Loto',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
