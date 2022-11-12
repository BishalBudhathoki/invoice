import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  final String email;
  // final String lastName;

  const HomeView({
    Key? key,
    required this.email,
    // required this.lastName,
  }) : super(key: key);

  @override
  _HomeViewControllerState createState() {
    return _HomeViewControllerState();
  }
}

class _HomeViewControllerState extends State<HomeView> {
  var eml;
  @override
  void initState() {
    print('init');
    try {
      getData();
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  var ins = {};
  ApiMethod apiMethod = new ApiMethod();
  Future<dynamic> getData() async {
    ins = await apiMethod.getInitData(widget.email);
    if (ins != null) {
      // print("INS: "+ins['firstName']!);
      setState(() {
        eml = ins;
      });
      return ins;
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // var email = prefs.getString('email');
    //
    // bool CheckValue = prefs.containsKey('email');
    // print ("Here" +CheckValue.toString());
    //var data = await ApiMethod().getInitData(prefs.getString('email')!);
    //return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorTry,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45),
                child: ProfilePlaceholder(
                  firstName: ins['firstName'] ?? 'First Name',
                  lastName: ins['lastName'] ?? 'Last Name',
                  image: Image.asset('assets/images/pari-profile.png'),
                ),
              ),
              SizedBox(height: context.height * 0.023),
              const Text('Your Appointments',
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
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
              SizedBox(
                  height: 348,
                  child: ListView(
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const Text('Add Client\'s Details ?',
                            style: TextStyle(
                              color: AppColors.colorFontPrimary,
                              fontSize: AppDimens.fontSizeLarge,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Lato',
                            )),
                        SizedBox(height: context.height * 0.023),
                        HomeDetailCard(
                          buttonLabel: 'Add Details',
                          cardLabel: 'Know Your Client!',
                          image: Image.asset(AssetsStrings.cardImageGirl),
                        ),
                        SizedBox(height: context.height * 0.023),
                        const Text('Add Business\'s Details ?',
                            style: TextStyle(
                              color: AppColors.colorFontPrimary,
                              fontSize: AppDimens.fontSizeLarge,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Lato',
                            )),
                        SizedBox(height: context.height * 0.023),
                        HomeDetailCard(
                          buttonLabel: 'Add Details',
                          cardLabel: 'Know Your Business!',
                          image: Image.asset(AssetsStrings.cardImageBoy)
                        )
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
