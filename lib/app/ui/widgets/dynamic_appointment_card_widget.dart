import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:invoice/app/core/view-models/assignedAppointment_model.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/app/ui/widgets/appointment_card_widget.dart';
import 'package:invoice/backend/api_method.dart';

class DynamicAppointmentCardWidget extends StatefulWidget {

  const DynamicAppointmentCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return _DynamicAppointmentCardWidgetState();
  }

}

class _DynamicAppointmentCardWidgetState extends State<DynamicAppointmentCardWidget> {
  late Future<List<Patient>> futureClientsData;
  late Future<List> futureData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var setAppointmentData;
  var appointmentData = {};
  ApiMethod apiMethod = ApiMethod();

  @override
  void initState() {
    super.initState();
    ApiMethod apiMethod = new ApiMethod();
    futureClientsData = ( apiMethod.fetchMultiplePatientData("alkc331@gmail.com,bishalkc331@gmail.com"));
    getAppointmentData();
  }

  Future<dynamic> getAppointmentData() async {
    appointmentData = (await apiMethod
        .getAppointmentData("Deverbishal331@gmail.com")) as Map;
    if (appointmentData != null) {
      setState(() {
        setAppointmentData = appointmentData;
        print('${appointmentData['data'][0]['startTimeList'][0]}');
      });
      return [appointmentData];
    }
  }

  @override
  Widget build(BuildContext context) {
    int ind = 1;
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Patient>>(
                future: futureClientsData,
                builder: (context, snapshot) {
                  //var ind = appointmentData['data'].length;
                  if (snapshot.hasData == true) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            AppointmentCard(
                              title: 'Appointments',
                              iconData: Iconsax.user_square,
                              label: 'Client\'s Name:',
                              text: "${snapshot.data![index].clientFirstName} ${snapshot.data![index].clientLastName}",
                              iconData1: Iconsax.location,
                              label1: 'Address:',
                              text1: "${snapshot.data![index].clientAddress} "
                                  "${snapshot.data![index].clientCity} "
                                  "${snapshot.data![index].clientState} "
                                  "${snapshot.data![index].clientZip}",
                              iconData2: Iconsax.timer_start,
                              label2: 'Start Time:',
                              text2: "${appointmentData['data'][index]['startTimeList'][ind]}",
                              iconData3: Iconsax.timer_pause,
                              label3: 'End Time:',
                              text3: "${appointmentData ['data'][index]['endTimeList'][0]}",
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ));
  }

}