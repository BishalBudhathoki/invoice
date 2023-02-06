import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/backend/api_method.dart';

class ClientAndAppointmentDetails extends StatefulWidget {
  final String email;

  const ClientAndAppointmentDetails({Key? key, required this.email})
      : super(key: key);

  @override
  _ClientAndAppointmentDetailsState createState() =>
      _ClientAndAppointmentDetailsState();
}

class _ClientAndAppointmentDetailsState
    extends State<ClientAndAppointmentDetails> {
  ApiMethod apiMethod = ApiMethod();
  var setClientAndAppointmentData;
  var clientAndAppointmentData = {};
  late Future<List<Patient>> futureClientsData;

  @override
  void initState() {
    super.initState();
    getAppointmentData();
    //futureClientsData = apiMethod.fetchPatientData();
  }

  Future<dynamic> getAppointmentData() async {
    clientAndAppointmentData =
        (await apiMethod.getAppointmentData(widget.email)) as Map;
    if (clientAndAppointmentData != null) {
      setState(() {
        setClientAndAppointmentData = clientAndAppointmentData;
      });
      print("client apt det: $clientAndAppointmentData");
      return clientAndAppointmentData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Client and Appointment Details',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Text("First Name:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?[0]?['clientEmail'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Email:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?[0]?['clientEmail'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Phone:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['phone'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Address:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['address'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("City:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['city'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("State:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['state'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Zip:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['zip'] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Appointment Date:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: RichText(
                    text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: '${clientAndAppointmentData['data']?[0]?['dateList'] ?? "No data found"}',
                              style: const TextStyle(
                                color: AppColors.colorFontPrimary,
                                fontSize: AppDimens.fontSizeXXMedium,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Lato',
                              )
                          )
                        ]
                    ),
                  ),
                ),
                ListTile(
                  leading: const Text("Appointment Time:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?[0]?['startTimeList']?[0] ?? "No data found"}',
                      style: const TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      )),
                ),
                ListTile(
                  leading: const Text("Breaks Allowed:",
                      style: TextStyle(
                        color: AppColors.colorFontPrimary,
                        fontSize: AppDimens.fontSizeXXMedium,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                      )),
                  title: const SizedBox(width: 20),
                  trailing:
                            Text('${clientAndAppointmentData['data']?[0]?['breakList']?[0] ?? "No data found"}',
                            style: const TextStyle(
                              color: AppColors.colorFontPrimary,
                              fontSize: AppDimens.fontSizeXXMedium,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                            )
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
