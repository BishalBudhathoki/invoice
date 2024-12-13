import 'dart:async';
import 'dart:io';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/core/utils/Services/launchMap_status.dart';
import 'package:MoreThanInvoice/app/features/client/models/client_model.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/core/services/timer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../notes/views/add_notes_view.dart';

const int kTimerDurationInSeconds = 8 * 60 * 60; // 8 hours

class ClientAndAppointmentDetails extends StatefulWidget {
  final String userEmail;
  final String clientEmail;
  final PersistentTabController? controller;

  const ClientAndAppointmentDetails({
    super.key,
    required this.userEmail,
    required this.clientEmail,
    this.controller,
  });

  @override
  _ClientAndAppointmentDetailsState createState() =>
      _ClientAndAppointmentDetailsState();
}

class _ClientAndAppointmentDetailsState
    extends State<ClientAndAppointmentDetails> {
  late final PersistentTabController controller;
  ApiMethod apiMethod = ApiMethod();
  var setClientAndAppointmentData;
  var clientAndAppointmentData = {};
  late Future<List<Patient>> futureClientsData;
  TimerService timerModel = TimerService();
  bool isCurrentClient = true;
  bool isInitCompleted = false;
  Map<String, dynamic>? _clientDetails;

  Map<String, dynamic>? get clientDetails => _clientDetails;

  set clientDetails(Map<String, dynamic>? value) {
    _clientDetails = value;
  }

  @override
  void initState() {
    super.initState();
    //_loadStartTime();
    timerModel = Provider.of<TimerService>(context, listen: false);
    getAppointmentData().then((_) {
      setState(() {
        isInitCompleted = true;
        clientDetails =
            clientAndAppointmentData['data']?['clientDetails']?.isNotEmpty ==
                    true
                ? clientAndAppointmentData['data']!['clientDetails'][0]
                : null;
      });
    });
    //futureClientsData = apiMethod.fetchPatientData();
  }

  Future<void> updateTimerModel() async {
    if (timerModel.isRunning &&
        timerModel
            .getTimerClientEmail()
            .contains(widget.clientEmail.toString())) {
      print("1 : ${widget.clientEmail} : ${timerModel.getTimerClientEmail()}");
      _stopTimer();
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
      await _startTimer();
      timerModel.setTimerClientEmail(widget.clientEmail);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getAppointmentData() async {
    clientAndAppointmentData = (await apiMethod.getClientAndAppointmentData(
        widget.userEmail, widget.clientEmail)) as Map;
    setState(() {
      print("Clinet Email: ${widget.clientEmail} "
          "${clientAndAppointmentData['data']?['clientDetails'][0]}");
      setClientAndAppointmentData = clientAndAppointmentData;
      isCurrentClient = (clientAndAppointmentData['data']?['clientDetails'][0]
              ?['clientEmail'] ==
          widget.clientEmail);
    });
    print("client apt det: $clientAndAppointmentData");
    return clientAndAppointmentData;
  }

  Future<dynamic> _startTimer() async {
    var startTime = await apiMethod.startTimer();
    // Store the start time in shared preferences
    final startTimeForLoading = DateTime.now().millisecondsSinceEpoch;
    _saveStartTime(startTimeForLoading);
    // Start your timer
    // timerModel.start();
    print("Start time: ");
  }

  void _saveStartTime(int startTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('startTimeForLoading', startTime);
  }

  void _loadStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final startTimeForLoading = prefs.getInt('startTime') ?? 0;
    if (startTimeForLoading > 0) {
      // Calculate the elapsed time since the start time
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final elapsedSeconds = (currentTime - startTimeForLoading) ~/ 1000;
      // Set the elapsed time in your timer model
      timerModel.setElapsedSeconds(elapsedSeconds);
    }
  }

// Call _loadStartTime when your app starts or when the widget initializes

  Future<dynamic> _stopTimer() async {
    var stopTime = await apiMethod.stopTimer();
    print("stopTime");
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

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [];

    // Add the heading
    rows.add(
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
    );

    List<dynamic> assignedClients =
        clientAndAppointmentData['data']?['assignedClient'] ?? [];

    for (var client in assignedClients) {
      rows.add(
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              client['dateList'].join("\n").toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              client['startTimeList'].join("\n").toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              client['endTimeList'].join("\n").toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              client['breakList'].join("\n").toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ]),
      );
    }

    return rows;
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 10),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Text("Full Name:",
                    style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientFirstName'] ?? "No"} ${clientAndAppointmentData['data']?['clientDetails'][0]?['clientLastName'] ?? "Name"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Text("Email:",
                    style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientEmail'] ?? "No data found"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Text("Phone:",
                    style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientPhone'] ?? "No data found"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Text("Address:",
                    style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientAddress'] ?? "No data found"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading:
                    Text("City:", style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientCity'] ?? "No data found"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading: Text("State:",
                    style: Theme.of(context).textTheme.bodyLarge),
                title: const SizedBox(width: 20),
                trailing: Text(
                    '${clientAndAppointmentData['data']?['clientDetails'][0]?['clientState'] ?? "No data found"}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                leading:
                    Text("Zip:", style: Theme.of(context).textTheme.bodyLarge),
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
                  children: _buildTableRows(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Ink(
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: (timerModel.isRunning &&
                              timerModel.getTimerClientEmail() ==
                                  widget.clientEmail)
                          ? AppColors.colorWarning
                          : AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border.fromBorderSide(BorderSide.none),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (timerModel.isRunning &&
                            timerModel.getTimerClientEmail() !=
                                widget.clientEmail) {
                          return; // disable the button if the timer is already running for another client
                        }
                        if (timerModel.isRunning &&
                            timerModel.getTimerClientEmail() ==
                                widget.clientEmail) {
                          _stopTimer();
                          timerModel.stop();
                          await _setWorkedTime();
                          print(timerModel
                              .getFormattedTime(timerModel.elapsedSeconds));
                          // add your function call here when the timer is stopped
                        } else {
                          await updateTimerModel();
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
              ),
              // const SizedBox(height: 15.0),
              Center(
                child: Text(
                  (timerModel.isRunning &&
                          (widget.clientEmail ==
                              timerModel.getTimerClientEmail()))
                      ? timerModel.getFormattedTime(timerModel.elapsedSeconds)
                      : timerModel.isRunning
                          ? "00:00:00" // Timer is running, display elapsed time
                          : timerModel.getFormattedTime(timerModel
                              .elapsedSeconds), // Timer is stopped, display total time as an integer
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    title: "View in Map",
                    onPressed: () {
                      if (clientDetails != null) {
                        final address = clientDetails?['clientAddress'] ?? '';
                        final city = clientDetails?['clientCity'] ?? '';
                        final state = clientDetails?['clientState'] ?? '';
                        final zipCode = clientDetails?['clientZipCode'] ?? '';
                        final fullAddress = '$address, $city, $state, $zipCode';
                        // Use the `fullAddress` variable to open the map
                        final status = launchMap(fullAddress);
                      }
                    },
                    hasBorder: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    title: "Add notes",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNotesView(
                              userEmail: widget.userEmail,
                              clientEmail: widget.clientEmail),
                        ),
                      );
                    },
                    hasBorder: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final TimerService timerModel = Provider.of<TimerService>(context);
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
      body: isInitCompleted ? _buildContent() : _buildProgressIndicator(),
    );
  }
}

Future<LaunchMapStatus> launchMap(String address) async {
  String query = Uri.encodeComponent(address);
  String geoUrl = 'geo:0,0?q=$query';
  String mapsUrl = 'comgooglemaps://?q=$query';
  if (Platform.isAndroid) {
    if (await canLaunchUrl(Uri.parse(geoUrl))) {
      await launchUrl(Uri.parse(geoUrl));
    } else {
      return LaunchMapStatus(
        success: false,
        title: 'Error',
        message: 'Could not launch Google Maps',
        backgroundColor: Colors.red,
      );
    }
  } else {
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    } else {
      return LaunchMapStatus(
        success: false,
        title: 'Error',
        message: 'Could not launch Google Maps',
        backgroundColor: Colors.red,
      );
    }
  }
  return LaunchMapStatus(
    success: true,
    title: 'Success',
    message: 'Launched Google Maps',
    backgroundColor: Colors.green,
  );
}
