import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:invoice/app/ui/views/assignC2E_view.dart';
import 'package:invoice/app/ui/views/photo_display_widget.dart';
import '../../../backend/api_method.dart';
import '../shared/values/colors/app_colors.dart';
import '../views/line_items_view.dart';

import 'package:flutter/services.dart' show SystemNavigator, MethodChannel;
import 'package:flutter/foundation.dart'
    show kIsWeb, kReleaseMode, TargetPlatform;

class NavBarWidget extends StatelessWidget {
  final BuildContext context;
  final String email;
  final String firstName;
  final String lastName;
  final Key? photoDisplayKey;
  final Uint8List? photoData;

  NavBarWidget({
    super.key,
    required this.context,
    required this.email,
    this.photoDisplayKey,
    this.photoData,
    required this.firstName,
    required this.lastName,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiMethod apiMethod = ApiMethod();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.5, // Adjust the width as needed
      child: Drawer(
        key: _scaffoldKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$firstName $lastName'),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: CircleAvatar(
                    radius: 27.5,
                    child: CircleAvatar(
                      radius: 27.5,
                      child: PhotoDisplayWidget(key: UniqueKey(), email: email),
                    ),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/Invo.gif'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Assign C 2 E',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () async => {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssignC2E(),
                  ),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Line Items',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () async => {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LineItemsView(),
                  ),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Update Holiday',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () async {
                var value = await apiMethod.uploadCSV();
                if (value['message'].toString() == "Upload successful") {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    backgroundColor: AppColors.colorSecondary,
                    duration: const Duration(seconds: 3),
                    titleText: const Text(
                      "Success",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: AppColors.colorFontSecondary,
                          fontFamily: "ShadowsIntoLightTwo"),
                    ),
                    messageText: const Text(
                      "Holiday list updated in database",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.colorFontSecondary,
                          fontFamily: "ShadowsIntoLightTwo"),
                    ),
                  ).show(_scaffoldKey.currentContext!);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Request',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () {},
              trailing: ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 20,
                  height: 20,
                  child: const Center(
                    child: Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Policies',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Exit',
                  style: TextStyle(
                      color: AppColors.colorBlack,
                      fontFamily: "ShadowsIntoLightTwo")),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                if (kIsWeb) {
                  // Handle exit for web platform
                  // This will not actually exit the web app, as it is not allowed in most browsers
                  // You can show a message or perform some other action instead
                  print('Exit not supported on the web platform');
                } else if (kReleaseMode) {
                  // Handle exit for release builds on Android and iOS
                  // Invoke the platform-specific exit method
                  const platform = MethodChannel('app.channel.shared.data');
                  platform.invokeMethod('exitApp');
                } else {
                  // Handle exit for debug builds (e.g., during development)
                  // In debug mode, use the SystemNavigator API to exit the app
                  SystemNavigator.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
