import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/app/core/view-models/user_model.dart';
import 'package:invoice/app/core/view-models/client_model.dart';
import 'package:provider/provider.dart';

class ApiMethod {
//API to authenticate user login
  final String _baseUrl = dotenv.env['BASE_URL'].toString();

  Future<dynamic> authenticateUser(String email, String password) async {
    // ApiResponse _apiResponse = new ApiResponse();
    var data;
    try {
      print('${_baseUrl}hello/$email');
      final response = await http.get(Uri.parse('${_baseUrl}hello/$email'));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          data = (json.decode(response.body));
          print("200");
          break;
      }
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }

  Future<List<User>> fetchUserData() async {
    print(Uri.parse('${_baseUrl}getUsers'));
    final response = await http.get(Uri.parse('${_baseUrl}getUsers'));
    if (response.statusCode == 200) {
      print("I am a response user: ${response.body}");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new User.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Patient>> fetchPatientData() async {
    print(Uri.parse('${_baseUrl}getClients'));
    final response = await http.get(Uri.parse('${_baseUrl}getClients'));
    if (response.statusCode == 200) {
      print("I am a response client: \n${response.body}");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Patient.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<dynamic> getInitData(String email) async {
    // ApiResponse _apiResponse = new ApiResponse();
    var data;
    try {
      print('${_baseUrl}initData/$email');
      final response = await http.get(Uri.parse('${_baseUrl}initData/$email'));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          data = (json.decode(response.body));
          print("200");
          break;
        case 400:
          data = (json.decode(response.body));
          print("Get init data: 400");
          break;
      }
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }

  Future<List<Patient>> fetchMultiplePatientData(String emails) async {
    print(Uri.parse('${_baseUrl}getMultipleClients/$emails'));
    print(emails.toString());
    final response =
        await http.get(Uri.parse('${_baseUrl}getMultipleClients/$emails'));
    if (response.statusCode == 200) {
      print("I am a response client: \n${response.body}");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Patient.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<dynamic> deleteHolidayItem(String id) async {
    print('${_baseUrl}deleteHoliday/$id');
    final response =
        await http.delete(Uri.parse('${_baseUrl}deleteHoliday/$id'));
    if (response.statusCode == 200) {
      //print("I am a response client: \n${response.body}");
      try {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else if (response.statusCode == 400) {
      print("Holiday not found");
    } else if (response.statusCode == 404) {
      throw Exception('Not Found!');
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<dynamic> addHolidayItem(Map<String, String> newHoliday) async {
    final response = await http.post(Uri.parse('${_baseUrl}addHolidayItem'),
        body: json.encode(newHoliday),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else if (response.statusCode == 400) {
      print("Bad request");
    } else if (response.statusCode == 404) {
      throw Exception('Not Found!');
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<dynamic> getAppointmentData(String email) async {
    print('${_baseUrl}loadAppointments/$email');
    final response =
        await http.get(Uri.parse('${_baseUrl}loadAppointments/$email'));
    if (response.statusCode == 200) {
      //print("I am a response client: \n${response.body}");
      try {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else {
      throw Exception('Unexpected error occured!');
    }

    // Return a default value after the try-catch block
  }

  Future<dynamic> setWorkedTimer(
      String userEmail, String clientEmail, String time) async {
    print('${_baseUrl}setWorkedTime/');
    final url = '${_baseUrl}setWorkedTime/';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      'User-Email': userEmail,
      'Client-Email': clientEmail,
      'TimeList': time,
    };
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(response.body);
        print("I am a response client: \n${response.body}");
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else if (response.statusCode == 400) {
      throw Exception('Bad request, please check your input data');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized, please check your API key');
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint not found');
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<dynamic> getClientAndAppointmentData(
      String userEmail, String clientEmail) async {
    print('${_baseUrl}loadAppointmentDetails/$userEmail/$clientEmail');
    final response = await http.get(
        Uri.parse('${_baseUrl}loadAppointmentDetails/$userEmail/$clientEmail'));
    if (response.statusCode == 200) {
      print("I am a response client: \n${response.body}");
      try {
        var jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else {
      throw Exception('Unexpected error occured!');
    }

    // Return a default value after the try-catch block
  }

  late Map<String, dynamic> data = {};

  Future<dynamic> checkEmail(String email) async {
    try {
      print('${_baseUrl}checkEmail/$email');
      //post method with body
      final response =
          await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          data = new Map<String, dynamic>.from(json.decode(response.body));
          //print("200"+ data['email']);
          break;
        case 400:
          data = new Map<String, dynamic>.from(json.decode(response.body));
          //print("400"+ data['email']);
          break;
      }
      //print("checkEmail: "+response.body);
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }

  Future<dynamic> login(String email, String password) async {
    print('${_baseUrl}login/$email/$password');

    try {
      final response =
          await http.get(Uri.parse('${_baseUrl}login/$email/$password'));
      print("Resp: ${response.statusCode}");

      Map<String, dynamic> data = {};

      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          if (kDebugMode) {
            print("200" + data['message']);
          }
          // Retrieve the user's role from the response and assign it to a variable
          String role = data['role'];

          return {
            'message': 'user found',
            'role': role,
          };

        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          if (kDebugMode) {
            print("400" + data['message']);
          }

          return {
            'message': 'user not found',
          };

        default:
          return {
            'message': 'Unknown error occurred',
          };
      }
    } catch (e) {
      // Handle any exception that occurs during the login process
      print("Exception: $e");
      return {
        'message': 'An error occurred during login',
      };
    }
  }

  Future<dynamic> uploadCSV() async {
    try {
      print('${_baseUrl}uploadCSV');
      final response = await http.post(Uri.parse('${_baseUrl}uploadCSV'));
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("200 ${data['message']}");
          return data;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("400 ${data['message']}");
          return data;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  late List<dynamic> businessNameList = [];
  Future<dynamic> getBusinessNameList() async {
    try {
      print('${_baseUrl}business-names');
      final response = await http.get(Uri.parse('${_baseUrl}business-names'));
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          if (data != null) {
            businessNameList = List<dynamic>.from(data);
            print(data);
          }
          print("200 ");
          return businessNameList;
        case 400:
          final data = json.decode(response.body);
          if (data != null) {
            businessNameList = List<dynamic>.from(data);
            print(data);
          }
          print("400 ");
          return businessNameList;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  late List<dynamic> holidaysList = [];
  Future<dynamic> getHolidays() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}getHolidays'));
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          if (data != null) {
            holidaysList = List<dynamic>.from(data);
          }
          print("200 ");
          return data;
        case 400:
          final data = json.decode(response.body);
          if (data != null) {
            holidaysList = List<dynamic>.from(data);
          }
          print("400 ");
          return data;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  late List<dynamic> list = [];

  Future<dynamic> getUserDocs() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}user-docs'));
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          print(data);
          if (data != null && data['userDocs'] is List<dynamic>) {
            list = data['userDocs'];
          }
          print("200 ");
          return data;
        case 400:
          final data = json.decode(response.body);
          if (data != null && data['userDocs'] is List<dynamic>) {
            list = data['userDocs'];
          }
          print("400 ");
          return data;
      }
    } on SocketException catch (e) {
      if (e.message.contains("Connection refused")) {
        print("Connection refused");
      } else {
        print("Other error: $e");
      }
    } catch (e) {
      print("Error get user docs: $e");
    }
  }
  //
  // Future<dynamic> signupUser(
  //   String firstName,
  //   String lastName,
  //   String email,
  //   String password,
  //   String abn,
  // ) async {
  //   // ApiResponse _apiResponse = new ApiResponse();
  //
  //   try {
  //     print('${_baseUrl}checkEmail/$email');
  //     //post method with body
  //     final response =
  //         await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
  //     //print(response.body);
  //     switch (response.statusCode) {
  //       case 200:
  //         data = new Map<String, dynamic>.from(json.decode(response.body));
  //         //print("200"+ data['email']);
  //         break;
  //       case 400:
  //         data = new Map<String, dynamic>.from(json.decode(response.body));
  //         //print("400"+ data['email']);
  //         break;
  //       case 500: //server error
  //         data = new Map<String, dynamic>.from(json.decode(response.body));
  //         //print("400"+ data['email']);
  //         break;
  //     }
  //     //print("checkEmail: "+response.body);
  //   } on SocketException {
  //     // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
  //   }
  //
  //   if (data['email'] == "Email not found") {
  //     try {
  //       print("${"Print me: " + data['email']} $email");
  //
  //       final response1 = await http.post(
  //         Uri.parse('${_baseUrl}signup/$email'),
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Accept": "application/json"
  //         },
  //         body: jsonEncode({
  //           "firstName": firstName,
  //           "lastName": lastName,
  //           "email": email,
  //           "password": password,
  //           "abn": abn
  //         }),
  //       );
  //       print(response1.body);
  //       switch (response1.statusCode) {
  //         case 200:
  //           data = new Map<String, dynamic>.from(json.decode(response1.body));
  //           print("200" + data['email']!);
  //           break;
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print("Email already exists");
  //   }
  //
  //   return data;
  // }

  Future<dynamic> signupUser(String firstName, String lastName, String email,
      String password, String abn, String role) async {
    try {
      final checkEmailResponse =
          await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
      print('${_baseUrl}checkEmail/$email');
      final checkEmailData = json.decode(checkEmailResponse.body);
      switch (checkEmailResponse.statusCode) {
        case 200:
          print("checkEmail: ${checkEmailData['email']}");
          return null;
        case 400:
          print("email not found");
          final signupResponse = await http.post(
            Uri.parse('${_baseUrl}signup/$email'),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonEncode({
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": password,
              "abn": abn,
              "role": role
            }),
          );
          print('${_baseUrl}signup/$email');
          switch (signupResponse.statusCode) {
            case 200:
              final signupData = json.decode(signupResponse.body);
              print("Signup successful: ${signupResponse.body}");
              return signupData;
            case 500:
              print("${signupResponse.statusCode}: ${signupResponse.body}");
              return null;
            default:
              print(
                  "Signup failed with status code ${signupResponse.statusCode}");
              return null;
          }
        case 500:
          print("Server error occurred");
          return null;
        default:
          print("Invalid response received");
          return null;
      }
    } on SocketException {
      print("Server error. Please retry");
      return null;
    }
  }

  Future<dynamic> addClient(
    String FirstName,
    String LastName,
    String Email,
    String Phone,
    String Address,
    String City,
    String State,
    String Zip,
    String businessName,
  ) async {
    try {
      print('${_baseUrl}addClient/ $Email');
      final response = await http.post(
        Uri.parse('${_baseUrl}addClient/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "clientFirstName": FirstName,
          "clientLastName": LastName,
          "clientEmail": Email,
          "clientPhone": Phone,
          "clientAddress": Address,
          "clientCity": City,
          "clientState": State,
          "clientZip": Zip,
          "businessName": businessName
        }),
      );
      print("Hello: $response $Zip");
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("200 " + data['message']!);
          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          break;
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<dynamic> addBusiness(
    String businessName,
    String businessEmail,
    String businessPhone,
    String businessAddress,
    String businessCity,
    String businessState,
    String businessZip,
  ) async {
    try {
      print('${_baseUrl}addBusiness/ $businessName');
      final response = await http.post(
        Uri.parse('${_baseUrl}addBusiness/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "businessName": businessName,
          "businessEmail": businessEmail,
          "businessPhone": businessPhone,
          "businessAddress": businessAddress,
          "businessCity": businessCity,
          "businessState": businessState,
          "businessZip": businessZip,
        }),
      );
      print("Hello: $response $businessZip");
      switch (response.statusCode) {
        case 200:
          data = new Map<String, dynamic>.from(json.decode(response.body));
          print("200 " + data['message']!);
          break;
        case 400:
          data = new Map<String, dynamic>.from(json.decode(response.body));
          break;
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<dynamic> assignClientToUser(
      String userEmail,
      String clientEmail,
      List dateList,
      List startTimeList,
      List endTimeList,
      List breakList) async {
    print('${_baseUrl}assignClientToUser');
    //post method with body
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}assignClientToUser/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "userEmail": userEmail,
          "clientEmail": clientEmail,
          "dateList": dateList,
          "startTimeList": startTimeList,
          "endTimeList": endTimeList,
          "breakList": breakList,
        }),
      );
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("200" + data['message']);

          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("400" + data['message']);

          break;
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getLineItems() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}getLineItems/'));
      switch (response.statusCode) {
        case 200:
          final List<dynamic> lineItemsJson = json.decode(response.body);
          final List<Map<String, dynamic>> lineItems = lineItemsJson
              .map((json) => Map<String, dynamic>.from(json))
              .toList();
          return lineItems;
        case 400:
          throw Exception('Failed to get line items: bad request');
        default:
          throw Exception('Failed to get line items: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Failed to get line items: network error');
    } catch (e) {
      throw Exception('Failed to get line items: $e');
    }
  }

  Future<List<String>> checkHolidays(List<String> workedDateList) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}check-holidays'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "dateList": workedDateList.join(','),
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> holidayStatusListJson = json.decode(response.body);
        final List<String> holidayStatusList =
            holidayStatusListJson.cast<String>();
        return holidayStatusList;
      } else {
        throw Exception('Failed to get holidays: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Failed to get holidays: network error');
    } catch (e) {
      throw Exception('Failed to get holidays: $e');
    }
  }

  Future<dynamic> uploadPhoto(
      BuildContext context, String userEmail, File imageFile) async {
    final url = '${_baseUrl}uploadPhoto/';
    final Uint8List photoData = await imageFile.readAsBytes();
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['email'] = userEmail;
    print("Email sending: ${request.fields['email']}");
    final imageStream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
    final imageSize = await imageFile.length();

    final multipartFile = http.MultipartFile('photo', imageStream, imageSize,
        filename: imageFile.path.split('/').last);
    request.files.add(multipartFile);

    final response = await request.send();
    if (response.statusCode == 200) {
      try {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        // After successful upload, set the photoData in the PhotoData instance
        final photoDataProvider =
            Provider.of<PhotoData>(context, listen: false);
        photoDataProvider.updatePhotoData(photoData);

        print("Response: $jsonResponse");
        return jsonResponse;
      } catch (e) {
        print("Error: $e");
      }
    } else if (response.statusCode == 400) {
      throw Exception('Bad request, please check your input data');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized, please check your API key');
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint not found');
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<Uint8List?> getUserPhoto(String userEmail) async {
    final url = '${_baseUrl}getUserPhoto/$userEmail';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final base64PhotoData = response.body;
      final photoData = base64Decode(base64PhotoData);
      return photoData;
    } else if (response.statusCode == 404) {
      throw Exception('Photo not found');
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
}
