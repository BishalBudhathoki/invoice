import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

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
    futureClientsData = (apiMethod.fetchMultiplePatientData(emails
        // "${widget.clientEmailList[0].toString()},${widget.clientEmailList[1].toString()}"
        //"alkc331@gmail.com,bishalkc331@gmail.com"

        ));
    setState(() {
      setFutureClientsData = futureClientsData;
    });
    //return futureClientsData;
    return [setFutureClientsData];
  }

  Future<dynamic> getAppointmentData() async {
    appointmentData =
        (await apiMethod.getAppointmentData(widget.currentUserEmail)) as Map;
    setState(() {
      setAppointmentData = appointmentData;
      print('DYCW ${appointmentData['data'][0]['startTimeList'][0]}');
    });
    return [appointmentData];
  }

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                            });
                          },
                          itemBuilder: (context, index) {
                            print(
                              "Current User Email: ${widget.currentUserEmail}",
                            );
                            print(
                              "Current Client Email: ${widget.clientEmailList[index]}",
                            );
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    AppointmentCard(
                                      currentClientEmail:
                                          widget.clientEmailList[index],
                                      currentUserEmail: widget.currentUserEmail,
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
                                          "${appointmentData['data'][index]['startTimeList'][index]}",
                                      iconData3: Iconsax.timer_pause,
                                      label3: 'End Time:',
                                      text3:
                                          "${appointmentData['data'][index]['endTimeList'][index]}",
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
