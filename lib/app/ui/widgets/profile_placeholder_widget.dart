import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class ProfilePlaceholder extends StatelessWidget {
  final String firstName;
  final String lastName;

  const ProfilePlaceholder({
    Key? key,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: context.height * 0.1,
      width: context.width * 0.6,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the left
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          const Text(
            'Welcome back',
            style: TextStyle(
              color: AppColors.colorFontPrimary,
              fontSize: AppDimens.fontSizeMedium,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$firstName $lastName',
            style: const TextStyle(
              color: AppColors.colorFontPrimary,
              fontSize: AppDimens.fontSizeLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
