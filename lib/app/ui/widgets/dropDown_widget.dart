
import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/views/timeAndDatePicker_view.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/confirmation_alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/flushbar_widget.dart';
import 'package:invoice/backend/api_method.dart';

class DropDownMenu extends StatefulWidget {
  final String userName;
  final String userEmail;

  const DropDownMenu(
      {super.key, required this.userName, required this.userEmail});

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}
 
class _DropdownMenuState extends State<DropDownMenu> {
  late Future<List<Patient>> futureClientsData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ApiMethod apiMethod = ApiMethod();
    futureClientsData = apiMethod.fetchPatientData();
  }
//_cardList.forEach((widget) {data.add(_focusedDay.toString());});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                            subtitle:
                                Text(snapshot.data![index].clientLastName),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (contextInside) {
                                  return ConfirmationAlertDialog(
                                    title: "Assign Client",
                                    content: "Are you sure you want to assign"
                                        " ${widget.userName} to"
                                        " ${snapshot.data![index].clientFirstName} "
                                        "${snapshot.data![index].clientLastName}?",
                                    confirmAction: () {
                                      // showAlertDialog(context);
                                      // Future.delayed(const Duration(seconds: 3),
                                      //     () async {
                                      //   var response =
                                      //       await _AssignClientToUser(
                                      //           widget.userEmail,
                                      //           snapshot
                                      //               .data![index].clientEmail);
                                      //   print(response['message']);
                                      //   if (response['message'].toString() ==
                                      //       "Success") {
                                      //     print("First: "+response['message']);
                                      //    //notify user if success
                                      //     Navigator.pop(context);
                                      //     FlushBarWidget fbw = new FlushBarWidget();
                                      //     fbw.flushBar(
                                      //       context: context,
                                      //        title: "Success",
                                      //        message: "Client assigned successfully",
                                      //        backgroundColor: AppColors.colorSecondary,
                                      //          );
                                      //     Future.delayed(const Duration(seconds: 3), () {
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //     });
                                      //
                                      //   } else {
                                      //     print("Second: "+response['message']);
                                      //     Navigator.pop(context);
                                      //     FlushBarWidget fbw = new FlushBarWidget();
                                      //     fbw.flushBar(
                                      //       context: context,
                                      //       title: "Error",
                                      //       message: "Client not assigned",
                                      //       backgroundColor: AppColors.error,
                                      //     );
                                      //     Future.delayed(const Duration(seconds: 3), () {
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //       Navigator.pop(context);
                                      //     });
                                      //   }
                                      // });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => TimeAndDatePicker(
                                          userEmail: widget.userEmail,
                                          clientEmail: snapshot.data![index].clientEmail,
                                          ),
                                          ));
                                    },
                                  );
                                },
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
                  print(snapshot.error);
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }



  // ApiMethod apiMethod = new ApiMethod();
  // Future<dynamic> _AssignClientToUser(
  //     String userEmail, String clientEmail) async {
  //   var ins = await apiMethod.assignClientToUser(userEmail, clientEmail);
  //   print("Response: " + ins.toString());
  //   return ins;
  // }
}
