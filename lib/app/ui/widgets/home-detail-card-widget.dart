import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/widgets/card_label_text_widget.dart';

class HomeDetailCard extends StatelessWidget {
  final String buttonLabel;
  final String cardLabel;
  final Image image;
  final VoidCallback onPressed;

  const HomeDetailCard({
    Key? key,
    required this.buttonLabel,
    required this.cardLabel,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 280,
      width: 350,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              height: context.height * 0.2,
              width: context.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: AppColors.colorFontSecondary,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 120, top: 40, right: 16),
                child: Text(
                    cardLabel,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.colorPrimary,
                      fontSize: AppDimens.fontSizeXXXMedium,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Lato',
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 200,
              width: 200,
              child: image,
            ),
          ),

          InkWell(
            onTap: onPressed,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200, left: 16, right: 16),
                  child: Container(
                    height: context.height * 0.06,
                    width: context.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: AppColors.colorPrimary,
                    ),
                    child: Center(
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: AppDimens.fontSizeMedium,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
