import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/holidayList_view.dart';
import 'package:invoice/app/ui/views/photo_display_widget.dart';
import 'package:invoice/app/ui/widgets/add_client_business_details_widget.dart';
import 'package:invoice/app/ui/widgets/appBar_widget.dart';
import 'package:invoice/app/ui/widgets/bottom_navBar_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/app/ui/widgets/navBar_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:invoice/notificationservice/local_notification_service.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/button_widget.dart';
import '../widgets/circular_profile_image_widget.dart';
import 'generateInvoice.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class AdminDashboardView extends StatefulWidget {
  final String email;

  const AdminDashboardView({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _AdminDashboardViewControllerState createState() {
    return _AdminDashboardViewControllerState();
  }
}

class _AdminDashboardViewControllerState extends State<AdminDashboardView> {
  var getInitialData;
  var initialData = {};
  ApiMethod apiMethod = ApiMethod();
  File? retrievedPhoto;
  Future<dynamic>? _photoFuture;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('init');
    try {
      getData();
      _photoFuture = apiMethod.getUserPhoto(widget.email);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    setState(() {
      getInitialData = initialData;
    });

    return initialData;
  }

  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> myWidgets = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Client\'s Details ?',
            style: TextStyle(
              color: AppColors.colorFontPrimary,
              fontSize: AppDimens.fontSizeLarge,
              fontWeight: FontWeight.w800,
              fontFamily: 'Lato',
            ),
          ),
          SizedBox(height: context.height * 0.023),
          HomeDetailCard(
            buttonLabel: 'Add Details',
            cardLabel: 'Know Your Client!',
            image: Image.asset(AssetsStrings.cardImageGirl),
            onPressed: () {
              print("Client Button Pressed");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddClientDetails()),
              );
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.height * 0.023),
          const Text(
            'Add Business\'s Details ?',
            style: TextStyle(
              color: AppColors.colorFontPrimary,
              fontSize: AppDimens.fontSizeLarge,
              fontWeight: FontWeight.w800,
              fontFamily: 'Lato',
            ),
          ),
          HomeDetailCard(
            buttonLabel: 'Add Details',
            cardLabel: 'Know Your Business!',
            image: Image.asset(AssetsStrings.cardImageBoy),
            onPressed: () {
              print("Business Button Pressed");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBusinessDetails()),
              );
            },
          ),
        ],
      ),
      // add more widgets here if you want multiple pages
    ];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          email: widget.email,
          firstName: initialData['firstName'] ?? 'First Name',
          lastName: initialData['lastName'] ?? 'Last Name',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.height * 0.025,
              ),
              SizedBox(
                height: context.height * 0.40,
                child: AddClientDetailsWidget(myWidgets: myWidgets),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  key: scaffoldKey,
                  children: [
                    ButtonWidget(
                      title: 'Edit Holidays',
                      hasBorder: false,
                      onPressed: () async {
                        List<dynamic>? holidays = await apiMethod.getHolidays();
                        if (holidays != null) {
                          print(holidays);
                          Navigator.push(
                            scaffoldKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HolidayListView(holidays: holidays),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      title: 'Generate Invoice',
                      hasBorder: false,
                      onPressed: () async {
                        Navigator.push(
                          scaffoldKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => const GenerateInvoice(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
