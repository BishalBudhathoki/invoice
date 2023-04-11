import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';

class ButtonWithVariableWH extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final double height;
  final double width;
  final VoidCallback onPressed;

  const ButtonWithVariableWH({
    Key? key,
    required this.title,
    required this.hasBorder,
    required this.onPressed,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: hasBorder ? AppColors.colorWhite : AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(
                  color: AppColors.colorPrimary,
                  width: 1.0,
                )
              : Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
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
