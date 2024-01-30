import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/views/adminDashBoard.dart';
import 'package:invoice/app/ui/views/assignC2E_view.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/views/photoUpload_view.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'navBar_widget.dart';

class BottomNavBarWidget extends StatefulWidget {
  final String email;
  final String role;
  const BottomNavBarWidget(
      {super.key, required this.email, required this.role});

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  late PersistentTabController _controller;
  var getInitialData;
  var initialData = {};
  late String role;
  late Uint8List? retrievedPhoto;
  PhotoData photoDataProvider = PhotoData();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    //retrievedPhoto = await apiMethod.retrievePhoto('user@example.com');
    // Call the function and pass the PhotoData instance
    // Uint8List? imageData =
    //     await apiMethod.getUserPhotoFromFBS(photoDataProvider);
    // print("Image data: $imageData");
    // The PhotoData change notifier is updated internally, and listeners will be notified.
    setState(() {
      getInitialData = initialData;
      // retrievedPhoto = imageData;
    });
    return initialData;
  }

  @override
  void initState() {
    _controller = Provider.of<PersistentTabController>(context, listen: false);
    getData();
    _controller = PersistentTabController(initialIndex: 0);
    role = widget.role;
    super.initState();
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    if (role == 'admin') {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: 'Search',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profile Photo',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: 'Settings',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profile Photo',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: 'Settings',
          activeColorPrimary: AppColors.colorPrimary,
          inactiveColorPrimary: AppColors.colorSecondary,
        ),
      ];
    }
  }

  List<Widget> _buildScreens(BuildContext buildContext) {
    return [
      Consumer<PhotoData>(
        builder: (buildContext, photoDataProvider, _) {
          if (role == 'admin') {
            print('admin');
            return AdminDashboardView(
              email: widget.email,
              photoData: photoDataProvider.photoData,
              controller: _controller,
              // other required parameters
            );
          } else {
            print('not admin');
            return HomeView(
              email: widget.email,
              photoData: photoDataProvider.photoData,
              controller: _controller,
              // other required parameters
            );
          }
        },
      ),
      if (role == 'admin') const AssignC2E(),
      PhotoUploadScreen(
        email: widget.email,
      ),
      Consumer<PhotoData>(
        builder: (buildContext, photoDataProvider, _) => NavBarWidget(
          context: buildContext,
          email: widget.email,
          firstName: initialData['firstName'] ?? 'First Name',
          lastName: initialData['lastName'] ?? 'Last Name',
          photoData: photoDataProvider.photoData,
          role: widget.role,
          controller: _controller,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //print("retrieved photo: $retrievedPhoto");
    return Scaffold(
      key: _scaffoldKey,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(context),
        items: _navBarItems(),
        navBarStyle: NavBarStyle.style1,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
