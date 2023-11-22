import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/user_model.dart';
import 'package:invoice/app/ui/widgets/dropDown_widget.dart';
import 'package:invoice/backend/api_method.dart';

import '../shared/values/colors/app_colors.dart';

class AssignC2E extends StatefulWidget {
  const AssignC2E({super.key});

  @override
  _AssignC2EState createState() => _AssignC2EState();
}

class _AssignC2EState extends State<AssignC2E> {
  ApiMethod apiMethod = ApiMethod();
  late Future<List<User>> futureUserData;
  // late Future<List<Patient>> futureClientsData;

  @override
  void initState() {
    super.initState();
    futureUserData = apiMethod.fetchUserData();
    // futureClientsData = apiMethod.fetchPatientData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee List',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUserData,
        builder: (context, snapshot) {
          print(snapshot.data?[0].firstName);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(snapshot.data![index].firstName,
                          style: Theme.of(context).textTheme.bodyMedium),
                      subtitle: Text(snapshot.data![index].email),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DropDownMenu(
                              userName: snapshot.data![index].firstName,
                              userEmail: snapshot.data![index].email,
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("User error: ${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
