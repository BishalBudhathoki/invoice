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
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Lato',
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
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: AppColors.colorWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Appointments',
                              style: TextStyle(
                                color: AppColors.colorPrimary,
                                fontSize: AppDimens.fontSizeXXXMedium,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Lato',
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text('Client\'s Name:',
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Loto',
                                  )),
                              Text('Matthew Perry',
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontFamily: 'Lato',
                                    //fontWeight: FontWeight.w900,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Address:',
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Loto',
                                  )),
                              Text('13 Carlton Cres, Summerhill, \n NSW 2130',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    //fontWeight: FontWeight.w900,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text('Start Time:',
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Helvetica Neue',
                                  )),
                              Text('05:00 PM',
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    //fontWeight: FontWeight.w900,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Text('End Time:',
                                  style: TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Loto',
                                  )),
                              Text('10:00 PM',
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    //fontWeight: FontWeight.w900,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
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

