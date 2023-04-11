import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/holidayList_view.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/app/ui/widgets/navBar_widget.dart';
import 'package:invoice/backend/api_method.dart';

import '../widgets/button_widget.dart';

class AdminDashboardView extends StatefulWidget {
  final String email;
  // final String lastName;

  const AdminDashboardView({
    Key? key,
    required this.email,
    // required this.lastName,
  }) : super(key: key);

  @override
  _AdminDashboardViewControllerState createState() {
    return _AdminDashboardViewControllerState();
  }
}

class _AdminDashboardViewControllerState extends State<AdminDashboardView> {
  int days = 10;

  var eml;
  var ins = {};
  ApiMethod apiMethod = new ApiMethod();

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

  Future<dynamic> getData() async {
    ins = await apiMethod.getInitData(widget.email);
    setState(() {
      eml = ins;
    });
    return ins;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.height * 0.1),
        child: AppBar(
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
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                child: SizedBox(
                  height: 55,
                  width: 55,
                  child: Image.asset(
                    'assets/images/pari-profile.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: NavBarWidget(
        context: context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 348,
                child: ListView(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 20),
                      const Text('Add Client\'s Details ?',
                          style: TextStyle(
                            color: AppColors.colorFontPrimary,
                            fontSize: AppDimens.fontSizeLarge,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Lato',
                          )),
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
                                builder: (context) =>
                                    const AddBusinessDetails()),
                          );
                        },
                      ),
                    ]),
              ),
              // FlutterCalendar(
              //   focusedDate: dateTime,
              //   isHeaderDisplayed: true,
              //   startingDayOfWeek: DayOfWeek.mon,
              //   selectionMode: CalendarSelectionMode.multiple,
              //
              //   // onMultipleDates: (List<DateTime> dates) {
              //   //   for (var date in dates) {
              //   //     datelist.add(date);
              //   //     print("Date: $date DateList: $datelist" );
              //   //   }
              //   // },
              //   // onDayPressed: (DateTime date) {
              //   //   datelist.remove(date);
              //   //   print("Pressed Date: $date DateList: $datelist");
              //   // },
              //   // onDayLongPressed: (DateTime date) {
              //   //   print("Long Pressed Date: $date");
              //   //
              //   // },
              // ),
              ButtonWidget(
                  title: 'Edit Holidays',
                  hasBorder: false,
                  onPressed: () async {
                    List<dynamic>? holidays = await apiMethod.getHolidays();
                    if (holidays != null) {
                      print(holidays);
                      Navigator.push(
                        _scaffoldKey.currentContext!,
                        MaterialPageRoute(
                            builder: (context) =>
                                HolidayListView(holidays: holidays)),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
