import 'dart:io';
import 'dart:typed_data';
import 'package:MoreThanInvoice/app/features/auth/models/user_role.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/line_items_view.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/Appointment/views/assignC2E_view.dart';
import 'package:MoreThanInvoice/app/features/auth/views/login_view.dart';
import 'package:MoreThanInvoice/app/shared/widgets/photo_display_widget.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../../backend/api_method.dart';

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
  final UserRole role;
  final PersistentTabController? controller;

  NavBarWidget({
    super.key,
    required this.context,
    required this.email,
    this.photoDisplayKey,
    this.photoData,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.controller,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiMethod apiMethod = ApiMethod();

  @override
  Widget build(BuildContext context) {
    print("Navbar widget photo data: $photoData");
    return Consumer<PhotoData>(
        builder: (context, photoDataProvider, _) {
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
                        child:
                            // PhotoDisplayWidget(key: UniqueKey(), email: email),
                        photoDataProvider.isLoading
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                          backgroundImage: photoDataProvider.photoData != null
                              ? MemoryImage(photoDataProvider.photoData!)
                              : const AssetImage('assets/icons/profile_placeholder.png')
                          as ImageProvider<Object>,
                        ),
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
              if (role == 'admin')
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
              if (role == 'admin')
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
              if (role == 'admin')
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
                leading: const Icon(Icons.delete_forever_outlined),
                title: const Text('Delete Account',
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontFamily: "ShadowsIntoLightTwo")),
                onTap: () {
                  // Show the delete confirmation dialog
                  _showDeleteConfirmationDialog(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Exit',
                    style: TextStyle(
                        color: AppColors.colorBlack,
                        fontFamily: "ShadowsIntoLightTwo")),
                leading: const Icon(Icons.exit_to_app),
                onTap: () async {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(
                        context); // Pop the current screen on both platforms
                  } else {
                    final role = getRole();
                    if (Platform.isAndroid) {
                      SystemNavigator.pop(); // Close the Android app
                    } else {
                      //exit(0);
                      const platform = MethodChannel('app.channel.shared.data');
                      platform.invokeMethod('exitApp');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );}
    );
  }

  String getRole() {
    final prefsUtils =
        Provider.of<SharedPreferencesUtils>(context, listen: false);
    UserRole? role = prefsUtils.getRole();
    print("Role: $role");
    return role.toString();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the delete operation
                _deleteAccount();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final response = await apiMethod.deleteUser(email);

      if (response.containsKey('message')) {
        if (response['message'].toString() == "User deleted successfully") {
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
              "User deleted successfully",
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.colorFontSecondary,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(_scaffoldKey.currentContext!);

          // Navigate to login after success message
          await Future.delayed(
              const Duration(seconds: 3)); // Delay for message visibility
          Navigator.of(_scaffoldKey.currentContext!).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        } else {
          // Handle other messages or errors
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            backgroundColor: AppColors.colorWarning,
            duration: const Duration(seconds: 3),
            titleText: const Text(
              "Error",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: AppColors.colorFontSecondary,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: const Text(
              "Failed to delete user, try again later",
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.colorFontSecondary,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          ).show(_scaffoldKey.currentContext!);
        }
      } else {
        // Handle unexpected response or errors
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          backgroundColor: AppColors.colorWarning,
          duration: const Duration(seconds: 3),
          titleText: const Text(
            "Server error",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: AppColors.colorFontSecondary,
                fontFamily: "ShadowsIntoLightTwo"),
          ),
          messageText: const Text(
            "Server error, try again later",
            style: TextStyle(
                fontSize: 16.0,
                color: AppColors.colorFontSecondary,
                fontFamily: "ShadowsIntoLightTwo"),
          ),
        ).show(_scaffoldKey.currentContext!);
      }
    } catch (error) {
      // Handle any errors during the API call
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: AppColors.colorSecondary,
        duration: const Duration(seconds: 3),
        titleText: const Text(
          "Error",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: AppColors.colorFontSecondary,
              fontFamily: "ShadowsIntoLightTwo"),
        ),
        messageText: Text(
          error.toString(),
          style: const TextStyle(
              fontSize: 16.0,
              color: AppColors.colorWarning,
              fontFamily: "ShadowsIntoLightTwo"),
        ),
      ).show(_scaffoldKey.currentContext!);
    }
  }
}
