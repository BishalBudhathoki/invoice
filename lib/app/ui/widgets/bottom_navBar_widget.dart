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
  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    //retrievedPhoto = await apiMethod.retrievePhoto('user@example.com');
    setState(() {
      getInitialData = initialData;
    });
    return initialData;
  }

  @override
  void initState() {
    getData();
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
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
        icon: const Icon(Icons.favorite),
        title: 'Favorites',
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

  List<Widget> _buildScreens() {
    return [
      Consumer<PhotoData>(
        builder: (context, photoDataProvider, _) {
          if (widget.role == 'admin') {
            print('admin');
            return AdminDashboardView(
              email: widget.email,
              // other required parameters
            );
          } else {
            print('not admin');
            return HomeView(
              email: widget.email,
              // other required parameters
            );
          }
        },
      ),
      const AssignC2E(),
      PhotoUploadScreen(
        email: widget.email,
      ),
      Consumer<PhotoData>(
        builder: (context, photoDataProvider, _) => NavBarWidget(
          context: context,
          email: widget.email,
          firstName: initialData['firstName'] ?? 'First Name',
          lastName: initialData['lastName'] ?? 'Last Name',
          photoData: photoDataProvider.photoData,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
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
