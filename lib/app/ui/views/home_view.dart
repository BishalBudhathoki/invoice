import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondary,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePlaceholder(
              firstName: 'Pratiksha',
              lastName: 'Tiwari',
              image: Image.asset('assets/images/pari-profile.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Your Appointments',
                style: TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: AppDimens.fontSizeXLarge,
                  fontWeight: FontWeight.w900,
                )),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(55)),
                      color: AppColors.colorWhite,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(55)),
                      color: AppColors.colorWhite,
                    ),
                  )
                ],
              )


            )
          ],
        ),
      ),
    );
  }
}

