import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:MoreThanInvoice/app/features/client/models/client_model.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import 'appointment_card_widget.dart';

class DynamicAppointmentCardWidget extends StatefulWidget {
  List clientEmailList;
  int listLength;
  String currentUserEmail;

  DynamicAppointmentCardWidget({
    super.key,
    required this.clientEmailList,
    required this.listLength,
    required this.currentUserEmail,
  });

  @override
  State<StatefulWidget> createState() {
    return _DynamicAppointmentCardWidgetState();
  }
}

class _DynamicAppointmentCardWidgetState
    extends State<DynamicAppointmentCardWidget> {
  late Future<List<Patient>> futureClientsData;
  late Future<List> futureData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var setAppointmentData;
  var setFutureClientsData;
  var appointmentData = {};
  ApiMethod apiMethod = ApiMethod();

  late int selectedPage;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    print("getFutureClientsData: ${widget.clientEmailList.toString()}");
    for (var i = 0; i < widget.listLength; i++) {
      print("getFutureClientsData: ${widget.clientEmailList[i]}");
    }
    print(
        "Dynamic: ${widget.currentUserEmail} ${widget.listLength.toString()}");
    getFutureClientsData();
    getAppointmentData();
  }

  Future<dynamic> getFutureClientsData() async {
    //print("getFutureClientsData: ${widget.clientEmailList[0]}");
    String emails = widget.clientEmailList.join(',');
    futureClientsData = (apiMethod.fetchMultiplePatientData(emails));
    setState(() {
      setFutureClientsData = futureClientsData;
    });
    //return futureClientsData;
    print("Future Clients Data: $futureClientsData");
    return [setFutureClientsData];
  }

  Future<dynamic> getAppointmentData() async {
    appointmentData =
        (await apiMethod.getAppointmentData(widget.currentUserEmail)) as Map;
    setState(() {
      setAppointmentData = appointmentData;
      print('DYCW ${appointmentData['data'][0]['startTimeList'][0]}');
    });
    print("Appointment Data: ${appointmentData.length}");
    return [appointmentData];
  }

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("Client email list: ${(widget.clientEmailList).length}\n");
    setFutureClientsData.then((list) {
      print('Length of setFutureClientsData: ${list.length}\n');
    });
    Future.delayed(const Duration(seconds: 1));
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Container(
            height: context.height * 0.33,
            color: AppColors.colorTransparent,
            child: FutureBuilder<List<Patient>>(
              future: setFutureClientsData,
              builder: (context, snapshot) {
                if (snapshot.hasData && setAppointmentData != null) {
                  debugPrint("Snapshot Data: ${snapshot.data!.length}");
                  return Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentPageIndex = index;
                              debugPrint("Current Page: $_currentPageIndex");
                            });
                          },
                          itemBuilder: (context, index) {
                            print(
                              "Current User Email: ${widget.currentUserEmail}",
                            );
                            print(
                              "Current Client Email $index : ${widget.clientEmailList[index]}",
                            );
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: AppointmentCard(
                                        currentClientEmail:
                                            widget.clientEmailList[index],
                                        currentUserEmail:
                                            widget.currentUserEmail,
                                        title: 'Appointments',
                                        iconData: Iconsax.user_square,
                                        label: 'Client\'s Name:',
                                        text:
                                            "${snapshot.data![index].clientFirstName} ${snapshot.data![index].clientLastName}",
                                        iconData1: Iconsax.location,
                                        label1: 'Address:',
                                        text1:
                                            "${snapshot.data![index].clientAddress} ${snapshot.data![index].clientCity} ${snapshot.data![index].clientState} ${snapshot.data![index].clientZip}",
                                        iconData2: Iconsax.timer_start,
                                        label2: 'Start Time:',
                                        text2:
                                            "${appointmentData['data'][0]['startTimeList'][0]}",
                                        iconData3: Iconsax.timer_pause,
                                        label3: 'End Time:',
                                        text3:
                                            "${appointmentData['data'][0]['endTimeList'][0]}",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // const SizedBox(
                      //   height: 6,
                      // ),
                      PageViewDotIndicator(
                        currentItem: _currentPageIndex,
                        count: snapshot.data!.length,
                        unselectedColor: AppColors.colorGrey,
                        selectedColor: AppColors.colorPrimary,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
