import 'dart:typed_data';

import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/appBar_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/dynamic_appointment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final String email;
  final Uint8List? photoData;
  final PersistentTabController? controller;
  // final String lastName;

  const HomeView({
    super.key,
    required this.email,
    this.photoData,
    this.controller,
    // required this.lastName,
  });

  @override
  _HomeViewControllerState createState() {
    return _HomeViewControllerState();
  }
}

class CardDetail {
  final String title;
  final String cardLabel;
  final String cardImage;
  final Widget navigateTo;

  CardDetail({
    required this.title,
    required this.cardLabel,
    required this.cardImage,
    required this.navigateTo,
  });
}

class _HomeViewControllerState extends State<HomeView> {
  final PageController _pageController = PageController();
  late final PersistentTabController controller;
  final int _currentPageIndex = 0;
  var eml;
  var initialData = {};
  var setAppointmentData;
  var appointmentData = {};
  late List<dynamic> clientEmailList = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('init');
    getInitData();
    getAppointmentData();
    super.initState();
  }

  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> getInitData() async {
    try {
      initialData = await apiMethod.getInitData(widget.email);
      // print("INS: "+ins['firstName']!);
      setState(() {
        eml = initialData;
      });
      return initialData;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAppointmentData() async {
    try {
      appointmentData =
          (await apiMethod.getAppointmentData(widget.email)) as Map;
      setState(() {
        setAppointmentData = appointmentData;
        // clientEmailList = appointmentData['data'].map((item) => item['clientEmail']).toList();
        // print("client email list: "+clientEmailList.toString());
      });
      return appointmentData;
    } catch (e) {
      print(e);
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
        preferredSize: const Size.fromHeight(70.0),
        child: Consumer<PhotoData>(
          builder: (context, photoDataProvider, _) {
            return CustomAppBar(
              email: widget.email,
              firstName: initialData['firstName'] ?? 'First Name',
              lastName: initialData['lastName'] ?? 'Last Name',
              photoData: photoDataProvider.photoData,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.025,
            ),
            const Text('Your Appointments',
                style: TextStyle(
                  color: AppColors.colorFontPrimary,
                  fontSize: AppDimens.fontSizeLarge,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Lato',
                )),
            //SizedBox(height: context.height * 0.023),
            Container(
              height: context.height * 0.34,
              width: context.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: AppColors.colorTransparent,
              ),
              child: ListView.builder(
                itemCount: getLength() == 0 ? 1 : getLength(),
                itemBuilder: (BuildContext context, int index) {
                  if (getLength() == 0) {
                    return SizedBox(
                      height: context.height *
                          0.38, // Set a fixed height for the "No Appointments" message
                      width: context
                          .width, // Set a fixed width for the "No Appointments" message
                      child: const Center(
                        child: Text(
                          'No Appointments right now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // filter the data in the setAppointmentData map based on the client email
                    var dataForClientEmail = setAppointmentData['data']
                        .map((item) => item['clientEmail'])
                        .toList();
                    print(
                        "data for client email: $dataForClientEmail ${dataForClientEmail.length} ${getLength()} $index");
                    // display the data for the client email
                    return SizedBox(
                      height: context.height *
                          0.38, // Set a fixed height for each item
                      width: context.width, // Set a fixed width for each item
                      child: DynamicAppointmentCardWidget(
                        currentUserEmail: widget.email,
                        listLength: dataForClientEmail.length,
                        clientEmailList: dataForClientEmail,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
