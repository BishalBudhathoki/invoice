import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice/app/ui/views/assignC2E_view.dart';
import '../../../backend/api_method.dart';
import '../shared/values/colors/app_colors.dart';
import '../views/line_items_view.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

class NavBarWidget extends StatelessWidget {
  final BuildContext context;
  NavBarWidget({required this.context});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiMethod apiMethod = ApiMethod();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scaffoldKey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Pratiksha Tiwari'),
            accountEmail: const Text('deverbishal331@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/pari-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Assign C 2 E'),
            onTap: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignC2E(),
                ),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Line Items'),
            onTap: () async => {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LineItemsView(),
                ),
              )
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DynamicAppointmentCardWidget(),
              //   ),
              // )
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Update Holiday'),
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
            title: const Text('Request'),
            onTap: () => null,
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
            title: const Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Policies'),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => {
              SystemNavigator.pop(),
            },
          ),
        ],
      ),
    );
  }
}
