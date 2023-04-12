import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:provider/provider.dart';
import 'package:invoice/app/core/timerModel.dart';

const int kTimerDurationInSeconds = 8 * 60 * 60; // 8 hours

class ClientAndAppointmentDetails extends StatefulWidget {
  final String userEmail;
  final String clientEmail;

  const ClientAndAppointmentDetails(
      {Key? key, required this.userEmail, required this.clientEmail})
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
  TimerModel timerModel = TimerModel();
//TimerModel timerModel = TimerModel();

  @override
  void initState() {
    super.initState();
    timerModel = Provider.of<TimerModel>(context, listen: false);
    getAppointmentData();
    //futureClientsData = apiMethod.fetchPatientData();
  }

  void updateTimerModel() {
    if (timerModel.isRunning &&
        timerModel
            .getTimerClientEmail()
            .contains(widget.clientEmail.toString())) {
      print("1 : ${widget.clientEmail} : ${timerModel.getTimerClientEmail()}");
      timerModel.stop();
      timerModel.setTimerClientEmail(widget.clientEmail);
    } else if (timerModel.isRunning &&
        (widget.clientEmail != timerModel.getTimerClientEmail())) {
      print("2");
      return;
    } else {
      print(
          "3: ${widget.clientEmail} : ${clientAndAppointmentData['data']?['clientDetails'][0]?['clientEmail']}");
      timerModel.start();
      timerModel.setTimerClientEmail(widget.clientEmail);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isCurrentClient = true;

  Future<dynamic> getAppointmentData() async {
    clientAndAppointmentData = (await apiMethod.getClientAndAppointmentData(
        widget.userEmail, widget.clientEmail)) as Map;
    if (clientAndAppointmentData != null) {
      setState(() {
        print(
            "Clinet Email: ${widget.clientEmail} ${clientAndAppointmentData['data']?['clientDetails'][0]}");
        setClientAndAppointmentData = clientAndAppointmentData;
        isCurrentClient = (clientAndAppointmentData['data']?['clientDetails'][0]
                ?['clientEmail'] ==
            widget.clientEmail);
      });
      print("client apt det: $clientAndAppointmentData");
      return clientAndAppointmentData;
    }
  }

  Future<dynamic> _setWorkedTime() async {
    var workedTime = await apiMethod.setWorkedTimer(
        widget.userEmail,
        widget.clientEmail,
        timerModel.getFormattedTime(timerModel.elapsedSeconds),
    );
    if (workedTime != null) {
      print("worked time: $workedTime");
      return workedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TimerModel timerModel = Provider.of<TimerModel>(context);
    String email = timerModel.getTimerClientEmail();
    final buttonTextStyle = TextStyle(color: Colors.white.withOpacity(0.5));
    print(
        "Cuurent Client: ${timerModel.getTimerClientEmail().toString().isNotEmpty}, ${widget.clientEmail}, ${timerModel.getTimerClientEmail()}");
    if (timerModel.elapsedSeconds == kTimerDurationInSeconds) {
      timerModel.stop();
    }
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
                const SizedBox(height: 10),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("Full Name:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientFirstName'] ?? "No"} ${clientAndAppointmentData['data']?['clientDetails'][0]?['clientLastName'] ?? "Name"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("Email:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientEmail'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("Phone:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientPhone'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("Address:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientAddress'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("City:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientCity'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("State:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientState'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text("Zip:",
                      style: Theme.of(context).textTheme.bodyLarge),
                  title: const SizedBox(width: 20),
                  trailing: Text(
                      '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientZip'] ?? "No data found"}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Table(
                    textDirection: TextDirection.ltr,
                    border: TableBorder.all(
                      color: AppColors.colorFontPrimary,
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(3.0),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: IntrinsicColumnWidth(),
                    },
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Appointment Date",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Start Time",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("End Time",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Breaks",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            textAlign: TextAlign.center,
                            (clientAndAppointmentData['data']?['assignedClient']
                            [0]?['dateList'] ??
                                ["No data found"])
                                .join("\n")
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            textAlign: TextAlign.center,
                            (clientAndAppointmentData['data']?['assignedClient']
                            [0]?['startTimeList'] ??
                                ["No data found"])
                                .join("\n")
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            textAlign: TextAlign.center,
                            (clientAndAppointmentData['data']?['assignedClient']
                            [0]?['endTimeList'] ??
                                ["No data found"])
                                .join("\n")
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            textAlign: TextAlign.center,
                            (clientAndAppointmentData['data']?['assignedClient']
                            [0]?['breakList'] ??
                                ["No data found"])
                                .join("\n")
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (timerModel.isRunning &&
                            timerModel.getTimerClientEmail() !=
                                widget.clientEmail) {
                          return; // disable the button if the timer is already running for another client
                        }
                        if (timerModel.isRunning &&
                            timerModel.getTimerClientEmail() ==
                                widget.clientEmail) {
                          timerModel.stop();
                          _setWorkedTime();
                          print(timerModel.getFormattedTime(timerModel.elapsedSeconds));
                          // add your function call here when the timer is stopped
                        } else {
                          updateTimerModel();
                          // add your function call here when the timer is started
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          (timerModel.isRunning &&
                                  timerModel.getTimerClientEmail() ==
                                      widget.clientEmail)
                              ? AppColors.colorWarning
                              : AppColors.colorPrimary,
                        ),
                        elevation: MaterialStateProperty.all(
                          timerModel.getTimerClientEmail() ==
                                      widget.clientEmail ||
                                  timerModel.isRunning
                              ? 0
                              : 2,
                        ),
                      ),
                      child: Text(
                        (timerModel.isRunning &&
                                timerModel.getTimerClientEmail() ==
                                    widget.clientEmail)
                            ? 'End shift'
                            : 'Start shift',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: Text(
                    timerModel.isRunning &&
                            (widget.clientEmail ==
                                timerModel.getTimerClientEmail())
                        ? timerModel.getFormattedTime(timerModel.elapsedSeconds)
                        : "00:00:00",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.blueGrey[800],
                    ),
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
