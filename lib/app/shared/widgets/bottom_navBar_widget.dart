import 'dart:typed_data';
import 'package:MoreThanInvoice/app/features/auth/models/user_role.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/features/admin/views/admin_dashboard_view.dart';
import 'package:MoreThanInvoice/app/features/Appointment/views/assignC2E_view.dart';
import 'package:MoreThanInvoice/app/features/home/views/home_view.dart';
import 'package:MoreThanInvoice/app/features/photo/views/photo_upload_view.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'navBar_widget.dart';

class BottomNavBarWidget extends StatefulWidget {
  final String email;
  final UserRole role;
  const BottomNavBarWidget(
      {super.key, required this.email, required this.role});

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  late PersistentTabController _controller;
  var getInitialData;
  var initialData = {};
  late UserRole role;
  late Uint8List? retrievedPhoto;
  PhotoData photoDataProvider = PhotoData();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> getData() async {
    initialData = await apiMethod.getInitData(widget.email);
    setState(() {
      getInitialData = initialData;
    });
    return initialData;
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  Future<void> initializeState() async {
    _controller = Provider.of<PersistentTabController>(context, listen: false);
    await getData();
    _controller = PersistentTabController(initialIndex: 0);
    role = widget.role;
    setRole(role);
  }

  void setRole(UserRole role) {
    final prefsUtils =
        Provider.of<SharedPreferencesUtils>(context, listen: false);
    prefsUtils.setRole(role);
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    //saveRole(role);
    if (widget.role == UserRole.admin) {
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

          if (widget.role == UserRole.admin) {
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
      if (widget.role == UserRole.admin) const AssignC2E(),
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
