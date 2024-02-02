import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';

class HomeDetailCard extends StatelessWidget {
  final String buttonLabel;
  final String cardLabel;
  final Image image;
  final VoidCallback onPressed;

  const HomeDetailCard({
    super.key,
    required this.buttonLabel,
    required this.cardLabel,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: AppColors.colorFontSecondary,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 40, right: 16),
                child: Text(
                  cardLabel,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 25),
            child: SizedBox(
              height: 200,
              width: 200,
              child: image,
            ),
          ),
          InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(top: 200, left: 16, right: 16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: AppColors.colorPrimary,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      buttonLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
