import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/user_model.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/backend/api_method.dart';

class DropDownMenu extends StatefulWidget {
  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropDownMenu> {

  late Future<List<Patient>> futureClientsData;

  @override
  void initState() {
    super.initState();
    ApiMethod apiMethod = new ApiMethod();
    futureClientsData = apiMethod.fetchPatientData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: FutureBuilder<List<Patient>>(
              future: futureClientsData,
              builder: (context, snapshot) {
                print(snapshot.hasData);
                if (snapshot.hasData == true) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(snapshot.data![index].clientFirstName),
                            subtitle: Text(snapshot.data![index].clientLastName),
                            trailing: Icon(Icons.arrow_forward_ios),

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
                  print(snapshot.error);
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              }
              ),
        )
    );
  }
}
