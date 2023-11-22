import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.title,
    required this.hasBorder,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? AppColors.colorWhite : AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(
                  color: AppColors.colorPrimary,
                  width: 1.0,
                )
              : const Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 60.0,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color:
                      hasBorder ? AppColors.colorPrimary : AppColors.colorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
