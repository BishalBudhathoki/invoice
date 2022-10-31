import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/widgets/card_label_text_widget.dart';

class HomeDetailCard extends StatelessWidget {
  const HomeDetailCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 170,
      width: 350,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.colorWhite,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(AssetsStrings.placeholderProduct),
                ),
                const Text('Appointment',
                    style: TextStyle(
                      color: AppColors.colorPrimary,
                      fontSize: AppDimens.fontSizeXXXMedium,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Lato',
                    )),
              ],
            ),
            Container(
              height: context.height * 0.06,
              width: context.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: AppColors.colorPrimary,
              ),
              child: const Center(
                child: Text(
                  'View Details',
                  style: TextStyle(
                    color: AppColors.colorWhite,
                    fontSize: AppDimens.fontSizeMedium,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
