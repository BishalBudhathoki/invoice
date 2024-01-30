import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/holidayList_view.dart';
import 'package:invoice/app/ui/widgets/add_client_business_details_widget.dart';
import 'package:invoice/app/ui/widgets/appBar_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:invoice/backend/shared_preferences_utils.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/button_widget.dart';
import 'generateInvoice.dart';

class AdminDashboardView extends StatefulWidget {
  final String email;
  final Uint8List? photoData;
  final PersistentTabController? controller;
  const AdminDashboardView({
    super.key,
    required this.email,
    this.photoData,
    this.controller,
  });

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
  Future<Uint8List?>? _photoFuture;
  SharedPreferencesUtils prefs = SharedPreferencesUtils();

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
      //_photoFuture = apiMethod.getUserPhoto(widget.email);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    print(" widget photo data ${widget.photoData}");
    setState(() {
      getInitialData = initialData;
    });

    return initialData;
  }

  final PageController _pageController = PageController();
  final int _currentPageIndex = 0;

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
                MaterialPageRoute(
                    builder: (context) => const AddClientDetails()),
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
                MaterialPageRoute(
                    builder: (context) => const AddBusinessDetails()),
              );
            },
          ),
        ],
      ),
      // add more widgets here if you want multiple pages
    ];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Consumer<PhotoData>(builder: (context, photoDataProvider, _) {
      return Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Consumer<PhotoData>(
            builder: (context, photoDataProvider, _) {
              final firstName = getInitialData?['firstName'] ?? 'First Name';
              final lastName = getInitialData?['lastName'] ?? 'Last Name';

              return CustomAppBar(
                email: widget.email,
                firstName: firstName,
                lastName: lastName,
                // photoData: photoDataProvider.photoData,
                photoData: Provider.of<PhotoData>(context).photoData,
              );
            },
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
                          List<dynamic>? holidays =
                              await apiMethod.getHolidays();
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
    });
  }
}
