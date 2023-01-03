import 'package:flutter/material.dart';
import 'package:invoice/backend/api_method.dart';

class ClientAndAppointmentDetails extends StatefulWidget {
  final String email;

  const ClientAndAppointmentDetails({
    Key? key,
    required this.email
  }) : super(key: key);

  @override
  _ClientAndAppointmentDetailsState createState() =>
      _ClientAndAppointmentDetailsState();
}

class _ClientAndAppointmentDetailsState
    extends State<ClientAndAppointmentDetails> {

  ApiMethod apiMethod = ApiMethod();
  var setClientAndAppointmentData;
  var clientAndAppointmentData = {};
  @override
  void initState() {
    super.initState();
    getAppointmentData();
    // futureClientsData = apiMethod.fetchPatientData();
  }

  Future<dynamic> getAppointmentData() async {
    clientAndAppointmentData = (await apiMethod.getAppointmentData(widget.email)) as Map;
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
        title: Text('Client and Appointment Details'),
      ),
      body: Column(
        children: [
          const Text('Client and Appointment Details',
              style: TextStyle(fontSize: 20)
          ),
          Text('First Name: ${clientAndAppointmentData['firstName'] ?? "Firstname"} '),
          Text('Email: ${clientAndAppointmentData['email'] ?? "Email"} '),
          Text('Phone: ${clientAndAppointmentData['phone'] ?? "Phone"} '),
          Text('Address: ${clientAndAppointmentData['address'] ?? "Address"} '),
          Text('City: ${clientAndAppointmentData['city'] ?? "City"} '),
          Text('State: ${clientAndAppointmentData['state'] ?? "State"} '),
          Text('Zip: ${clientAndAppointmentData['zip'] ?? "Zip"} '),
          Text('Appointment Date: ${clientAndAppointmentData['data'][0]['dateList'] ?? "Appointment Date"} '),
          Text('Appointment Time: ${clientAndAppointmentData['data'][0]['startTimeList'][0] ?? "Appointment Time"} '),
          Text('Breaks Allowed: ${clientAndAppointmentData['data'][0]['breakList'][0] ?? "Break Allowed"} '),

        ],
      ),
    );
  }
}
