import 'dart:io';
import 'dart:typed_data';
import 'package:MoreThanInvoice/app/features/invoice/views/GenerateInvoiceForAllUser.dart';
import 'package:MoreThanInvoice/app/features/invoice/views/add_update_invoice_email_view.dart';
import 'package:MoreThanInvoice/app/features/invoice/views/generateInvoice.dart';
import 'package:MoreThanInvoice/app/features/invoice/views/invoice_email_view.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/strings/asset_strings.dart';
import 'package:MoreThanInvoice/app/shared/widgets/add_client_business_details_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/appBar_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/home-detail-card-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/features/busineess/views/add_business_details_view.dart';
import 'package:MoreThanInvoice/app/features/client/views/add_client_details_view.dart';
import 'package:MoreThanInvoice/app/features/holiday/views/holiday_list_view.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

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
  late String key;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    debugPrint('init');
    try {
      getData();
      checkKey(widget.email).then((value) {
        key = value;
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    debugPrint(" widget photo data ${widget.photoData}");
    setState(() {
      getInitialData = initialData;
    });

    return initialData;
  }

  Future<String> checkKey(String email) async {
    try {
      debugPrint("checking key for $email");
      final response = await apiMethod.checkInvoicingEmailKey(email);

      if (response['message'] == 'Invoicing email key found') {
        if (response['key'] == null) {
          return 'add';
        } else {
          return response['key'];
        }
      } else if (response['message'] == 'No invoicing email key found') {
        return 'add';
      } else if (response['message'] ==
          'Error retrieving invoicing email key details') {
        return 'error';
      } else {
        return 'unknown';
      }
    } catch (e) {
      print(e);
      return 'error';
    }
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
              debugPrint("Client Button Pressed");
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
              debugPrint("Business Button Pressed");
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
                              builder: (context) =>
                                  GenerateInvoice(widget.email, key),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        title: 'Generate Invoice For All',
                        hasBorder: false,
                        onPressed: () async {
                          Navigator.push(
                            scaffoldKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GenerateInvoiceForAllUser(widget.email, key),
                              // GenerateInvoice(widget.email, key),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        title: 'Check Invoicing Email Details',
                        hasBorder: false,
                        onPressed: () {
                          checkKey(widget.email).then((value) {
                            debugPrint('Value: $value');
                            if (value == 'add' ||
                                value == 'error' ||
                                value == 'unknown') {
                              Navigator.push(
                                scaffoldKey.currentContext!,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddUpdateInvoicingEmailView(
                                          widget.email, value),
                                ),
                              );
                            } else if (value == 'error') {
                              print('Error retrieving invoicing email key');
                            } else if (value == 'unknown') {
                              print('Unknown error');
                            } else {
                              Navigator.push(
                                scaffoldKey.currentContext!,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InvoicingEmailView(widget.email, value),
                                ),
                              );
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
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
