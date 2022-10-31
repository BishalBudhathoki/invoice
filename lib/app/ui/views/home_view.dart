import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/app/ui/widgets/card_label_text_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondary,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: ProfilePlaceholder(
                firstName: 'Pratiksha',
                lastName: 'Tiwari',
                image: Image.asset('assets/images/pari-profile.png'),
              ),
            ),
            SizedBox(height: context.height * 0.023),
            const Text('Your Appointments',
                style: TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: AppDimens.fontSizeXLarge,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Lato',
                )),
            SizedBox(height: context.height * 0.023),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const AppointmentCard(
                    title: 'Appointments',
                    iconData: Iconsax.user_square,
                    label: 'Client\'s Name:',
                    text: 'Matthew Perry',
                    iconData1: Iconsax.location,
                    label1: 'Address:',
                    text1: '13 Carlton Cres, Summerhill',
                    iconData2: Iconsax.timer_start,
                    label2: 'Start Time:',
                    text2: '05:00 PM',
                    iconData3: Iconsax.timer_pause,
                    label3: 'End Time:',
                    text3: '10:00 PM',
                  ),
                  SizedBox(
                    width: context.width * 0.04,
                  ),
                  const AppointmentCard(
                    title: 'Appointments',
                    iconData: Iconsax.user_square,
                    label: 'Client\'s Name:',
                    text: 'Tim Crook',
                    iconData1: Iconsax.location,
                    label1: 'Address:',
                    text1: '13 Friday Cres, Ashfield',
                    iconData2: Iconsax.timer_start,
                    label2: 'Start Time:',
                    text2: '04:00 PM',
                    iconData3: Iconsax.timer_pause,
                    label3: 'End Time:',
                    text3: '09:00 PM',
                  ),
                ],
              ),
            ),
            SizedBox(height: context.height * 0.023),
            //SizedBox(height: context.height * 0.023),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(25),
            //     color: AppColors.colorWhite,
            //   ),
            //   child: Container(
            //     height: context.height * 0.06,
            //     width: context.width,
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(25)),
            //       color: AppColors.colorPrimary,
            //     ),
            //     child: const Center(
            //       child: Text(
            //         'Add Details',
            //         style: TextStyle(
            //           color: AppColors.colorWhite,
            //           fontSize: AppDimens.fontSizeMedium,
            //           fontWeight: FontWeight.w900,
            //           fontFamily: 'Lato',
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
                height: 348,
                child: ListView(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Text('Add Client\'s Details ?',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppDimens.fontSizeLarge,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Lato',
                          )),
                      SizedBox(height: context.height * 0.023),
                      const HomeDetailCard(),
                      SizedBox(height: context.height * 0.023),
                      const Text('Add Business\'s Details ?',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppDimens.fontSizeLarge,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Lato',
                          )),
                      SizedBox(height: context.height * 0.023),
                      const HomeDetailCard()
                    ]
                )),

          ],
        ),
      ),
    );
  }
}
