import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class AppBarTitle extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const AppBarTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50,
        color: AppColors.colorPrimary,
        child: Center(
          child: Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: AppDimens.fontSizeXXXMedium,
                color: AppColors.colorWhite,
              )),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}
