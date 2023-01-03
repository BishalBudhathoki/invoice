import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/adminDashBoard.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/app/ui/widgets/dynamic_appointment_card_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/backend/api_method.dart';

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
  var ins = {};

  var setAppointmentData;
  var appointmentData = {};
  late List<dynamic> clientEmailList = [];

  @override
  void initState() {
    print('init');
    getInitData();
    getAppointmentData();
    super.initState();
  }

  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> getInitData() async {
    ins = await apiMethod.getInitData(widget.email);
    if (ins != null) {
      // print("INS: "+ins['firstName']!);
      setState(() {
        eml = ins;
      });
      return ins;
    }
  }
  Future<dynamic> getAppointmentData() async {
    appointmentData = (await apiMethod.getAppointmentData(widget.email)) as Map;
    if (appointmentData != null) {
      setState(() {
        setAppointmentData = appointmentData;
        // clientEmailList = appointmentData['data'].map((item) => item['clientEmail']).toList();
        // print("client email list: "+clientEmailList.toString());
      });
      return appointmentData;
    }
  }

  int getLength() {
    if (setAppointmentData != null) {
      return setAppointmentData['data'].length;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.height * 0.1),
        child:  AppBar(
          toolbarHeight: context.height * 0.1,
          backgroundColor: AppColors.colorWhite,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                ProfilePlaceholder(
                  firstName: ins['firstName'] ?? 'First Name',
                  lastName: ins['lastName'] ?? 'Last Name',
                  //image: Image.asset(AssetStrings.profileImage),
                  // onPressed: () {
                  //   // NavDrawer();
                  //
                  // },
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 55,
                width: 55,
                child: InkWell(
                    onTap: () {
                      print('clicked');
                      //print(clientEmailList.toString());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //
                      //       builder: (context) => DynamicAppointmentCardWidget(
                      //         clientEmailList: clientEmailList,)),
                      // );
                    },

                    child: Image.asset('assets/images/pari-profile.png',)
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(

        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: context.height * 0.023),
              const Text('Your Appointments',
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
                    fontSize: AppDimens.fontSizeXLarge,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Lato',
                  )),
              SizedBox(height: context.height * 0.023),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       AppointmentCard(
              //         title: 'Appointments',
              //         iconData: Iconsax.user_square,
              //         label: 'Client\'s Name:',
              //         text: 'Matthew Perry',
              //         iconData1: Iconsax.location,
              //         label1: 'Address:',
              //         text1: '13 Carlton Cres, Summerhill',
              //         iconData2: Iconsax.timer_start,
              //         label2: 'Start Time:',
              //         text2: '05:00 PM',
              //         iconData3: Iconsax.timer_pause,
              //         label3: 'End Time:',
              //         text3: '10:00 PM',
              //       ),
              //       SizedBox(
              //         width: context.width * 0.04,
              //       ),
              //       const AppointmentCard(
              //         title: 'Appointments',
              //         iconData: Iconsax.user_square,
              //         label: 'Client\'s Name:',
              //         text: 'Tim Crook',
              //         iconData1: Iconsax.location,
              //         label1: 'Address:',
              //         text1: '13 Friday Cres, Ashfield',
              //         iconData2: Iconsax.timer_start,
              //         label2: 'Start Time:',
              //         text2: '04:00 PM',
              //         iconData3: Iconsax.timer_pause,
              //         label3: 'End Time:',
              //         text3: '09:00 PM',
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  height: context.height * 0.35,
                  width: context.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: AppColors.colorTransparent,
                  ),
                  child: ListView.builder(
                    itemCount: getLength(),
                    itemBuilder: (BuildContext context, int index) {
                      // filter the data in the setAppointmentData map based on the client email
                      var dataForClientEmail = setAppointmentData['data'].map((item) =>
                      item['clientEmail']).toList();
                      print("data for client email: $dataForClientEmail ${getLength()}");
                      // display the data for the client email
                      return  Container(
                        height: context.height * 0.35,
                        width: context.width,

                        child: DynamicAppointmentCardWidget(
                          currentUserEmail: widget.email,
                          listLength: dataForClientEmail.length,
                          clientEmailList: dataForClientEmail,
                        ),
                      );
                    },
                  )

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
                          onPressed: () {
                            print("Client Button Pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddClientDetails()),
                            );
                          },
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
                          image: Image.asset(AssetsStrings.cardImageBoy),
                          onPressed: () {
                            print("Business Button Pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddBusinessDetails()),
                            );
                          },
                        )
                      ])),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: _showBottomNav(),
    );
  }
}
