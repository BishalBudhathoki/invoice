import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/core/view-models/user_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui//widgets/profile_placeholder_widget.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';
import 'package:invoice/app/ui/views/add_business_details_view.dart';
import 'package:invoice/app/ui/views/add_client_details_view.dart';
import 'package:invoice/app/ui/views/assignClient_view.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/app/ui/widgets/home-detail-card-widget.dart';
import 'package:invoice/app/ui/widgets/navBar_widget.dart';
import 'package:invoice/app/ui/widgets/optionMenu_widget.dart';
import 'package:invoice/backend/api_method.dart';

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
    if (ins != null) {
      // print("INS: "+ins['firstName']!);
      setState(() {
        eml = ins;
      });
      return ins;
    }
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
      endDrawer: const NavBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
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
                ),

              ]),
        ),
      ),
    );
  }
}
