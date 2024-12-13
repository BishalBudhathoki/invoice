import 'dart:convert';
import 'dart:io';
import 'package:MoreThanInvoice/app/core/utils/Services/uploadNotes.dart';
import 'package:MoreThanInvoice/app/features/auth/models/user_role.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/utils/encryption/encrypt_decrypt.dart';
import 'package:MoreThanInvoice/app/shared/utils/encryption/encryption_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:MoreThanInvoice/app/core/services/timer_service.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/features/auth/models/user_model.dart'
    as app;
import 'package:MoreThanInvoice/app/features/client/models/client_model.dart';
import 'package:provider/provider.dart';

class ApiMethod extends ChangeNotifier {
//API to authenticate user login
  final String _baseUrl = kReleaseMode
      ? dotenv.env['RELEASE_URL'].toString()
      : dotenv.env['DEBUG_URL'].toString();
  TimerService timerModel = TimerService();

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

  Future<dynamic> startTimer() async {
    final response = await http.post(Uri.parse('${_baseUrl}startTimer'));
    print(response.body);

    switch (response.statusCode) {
      case 200:
        print("Timer Started");
        break;

      case 400:
        print("Timer failed");
        break;
    }
  }

  Future<void> stopTimer() async {
    final response = await http.post(Uri.parse('${_baseUrl}stopTimer'));
    print(response.body);
    var totalTimeFromTimer;
    switch (response.statusCode) {
      case 200:
        print("Timer stopped");
        totalTimeFromTimer = json.decode(response.body);
        timerModel.setTotalTime(totalTimeFromTimer['totalTime'].toInt());
        print("Total time from timer: ${timerModel.totalTime}");
        notifyListeners(); // Notify listeners after updating totalTime
        break;

      case 400:
        print("Timer failed");
        break;
    }
  }

  Future<List<app.User>> fetchUserData() async {
    print(Uri.parse('${_baseUrl}getUsers'));
    final response = await http.get(Uri.parse('${_baseUrl}getUsers'));
    if (response.statusCode == 200) {
      print("I am a response user: ${response.body}");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => app.User.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Map<String, dynamic>> sendOTP(
      String email, String encryptionKey) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}sendOTP'),
      body: jsonEncode({'email': email, 'clientEncryptionKey': encryptionKey}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send OTP');
    }

    // switch (response.statusCode) {
    //   case 200:
    //     final Map<String, dynamic> responseData = json.decode(response.body);
    //     print("200: $responseData ${responseData['statuesCode']}");
    //     return {
    //       'statusCode': responseData['statusCode'],
    //       'message': responseData['message']
    //     }; // Return the message
    //   case 400:
    //     final Map<String, dynamic> responseData = json.decode(response.body);
    //     print("400: $responseData ${responseData['statuesCode']}");
    //     return {
    //       'statusCode': responseData['statusCode'],
    //       'message': responseData['message']
    //     }; // Return the message
    //   case 500:
    //     final Map<String, dynamic> responseData = json.decode(response.body);
    //     print("500: $responseData");
    //     return {
    //       'statusCode': responseData['statusCode'],
    //       'message': responseData['message']
    //     }; // Return the message
    //   default:
    //     final Map<String, dynamic> responseData = json.decode(response.body);
    //     return {
    //       'statusCode': responseData['statusCode'],
    //       'message': responseData['message']
    //     }; // Handle other status codes as needed
    // }
  }

  Future<Map<String, dynamic>> verifyOTP(
    String userOtp,
    String userVerificationKey,
    String generatedOtp,
    String encryptVerificationKey,
  ) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}verifyOTP'),
      body: jsonEncode({
        'userOTP': userOtp,
        'userVerificationKey': userVerificationKey,
        'generatedOTP': generatedOtp,
        'encryptVerificationKey': encryptVerificationKey,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['statusCode'] == 200) {
        // OTP verification successful
        return result;
      } else {
        // OTP verification failed, handle accordingly
        throw Exception(result['message']);
      }
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> changePassword(
      String hashedPasswordWithSalt, String email) async {
    Map<String, dynamic> data = {};

    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}updatePassword'),
        body: jsonEncode({'newPassword': hashedPasswordWithSalt, 'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("200: ${data}");
          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          print("400: ${data['message']}");
          break;
        default:
          print("Unhandled status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error if needed
    }

    return data;
  }

  Future<String> firebaseUpdatePassword(
      String newPassword, String email) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: newPassword);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);

      print('Password updated!');
      return "Password updated!";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // Future<Map<String, dynamic>> sendOTP(String emailRecipient) async {
  //   print("Send OTP called");
  //   print(Uri.parse('${_baseUrl}sendOTP'));
  //
  //   final Map<String, dynamic> requestBody = {
  //     'email': emailRecipient,
  //     // Add any other parameters you need for the email service
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse('${_baseUrl}sendOTP'),
  //     body: json.encode(requestBody),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   switch (response.statusCode) {
  //     case 200:
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print("200: $responseData ${responseData['statuesCode']}");
  //       return {
  //         'statusCode': responseData['statusCode'],
  //         'message': responseData['message']
  //       }; // Return the message
  //     case 400:
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print("400: $responseData ${responseData['statuesCode']}");
  //       return {
  //         'statusCode': responseData['statusCode'],
  //         'message': responseData['message']
  //       }; // Return the message
  //     case 500:
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print("500: $responseData");
  //       return {
  //         'statusCode': responseData['statusCode'],
  //         'message': responseData['message']
  //       }; // Return the message
  //     default:
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       return {
  //         'statusCode': responseData['statusCode'],
  //         'message': responseData['message']
  //       }; // Handle other status codes as needed
  //   }
  // }

  Future<List<Patient>> fetchPatientData() async {
    print(Uri.parse('${_baseUrl}getClients'));
    final response = await http.get(Uri.parse('${_baseUrl}getClients'));
    if (response.statusCode == 200) {
      print("I am a response client: \n${response.body}");
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Patient.fromJson(data)).toList();
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

  Future<Map<String, dynamic>?> checkEmail(String email) async {
    try {
      print('${_baseUrl}checkEmail/$email');
      //post method with body
      final response =
          await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("200"+ data['email']);
          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("400"+ data['email']);
          break;
      }
      //print("checkEmail: "+response.body);
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }

  Future<Map<String, dynamic>> deleteUser(String email) async {
    try {
      print('${_baseUrl}deleteUser/$email');
      //post method with body
      final response = await http.delete(Uri.parse('${_baseUrl}deleteUser/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}));
      //print(response.body);
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("200"+ data['email']);
          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("400"+ data['email']);
          break;
      }
      //print("checkEmail: "+response.body);
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }

  Future<Map<String, dynamic>> getSalt(String email) async {
    try {
      print('${_baseUrl}getSalt/$email');
      //post method with body
      final response = await http.post(Uri.parse('${_baseUrl}getSalt/'),
          body: jsonEncode({'email': email}),
          headers: {'Content-Type': 'application/json'});
      print("Salt me: ${response.body} ${response.statusCode}");
      switch (response.statusCode) {
        case 200:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("200" + data['email']);
          break;
        case 400:
          data = Map<String, dynamic>.from(json.decode(response.body));
          //print("400" + data['email']);
          break;
      }
      //print("checkEmail: " + response.body);
    } on SocketException {
      //_apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    debugPrint("Salt getSalt: $data");
    return data;
  }

  Future<dynamic> login(String email, String password) async {
    // print('${_baseUrl}login/$email/$password');

    try {
      EncryptionUtils encryptionUtils = EncryptionUtils();
      final getSaltResponse = await getSalt(email);
      debugPrint("inside login: $getSaltResponse");
      debugPrint("getSaltResponse: $getSaltResponse.body");
      final salt = getSaltResponse['salt'];
      final Uint8List originalSalt = encryptionUtils.hexStringToUint8List(salt);
      print("Salty: $salt");

      var hashedPasswordWithSalt = encryptionUtils
          .encryptPasswordWithArgon2andSalt(password, originalSalt);
      print("Hashed password with salt: $hashedPasswordWithSalt");
      final response = await http.post(
        Uri.parse('${_baseUrl}login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'password': hashedPasswordWithSalt},
      );

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
          UserRole roleEnum;
          // Convert the string role to the UserRole enum
          if (role == 'admin') {
            roleEnum = UserRole.admin;
          } else {
            roleEnum = UserRole.normal;
          }
          debugPrint("Role enum: \n$roleEnum $role");
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
            'message': 'User not found',
          };

        default:
          return {
            'message': 'Unknown error occurred',
          };
      }
    } catch (e) {
      // Handle any exception that occurs during the login process
      print("Exception api method: $e");
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
            print("Holiday list: $holidaysList");
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
            debugPrint("\nlist of all assigned clients:\n $list");
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

  Future<Map<String, dynamic>?> getAssignedClients() async {
    try {
      debugPrint("getAssignedClients called");
      final response =
          await http.get(Uri.parse('${_baseUrl}assigned-client-data'));
      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> data = json.decode(response.body);
          print(data);
          if (data != null && data['assignedClientData'] is List<dynamic>) {
            list = data['assignedClientData'];
            //debugPrint("\nlist of all assigned clients:\n $list");
          }
          print("200 ");
          return data;
        case 400:
          final data = json.decode(response.body);
          if (data != null && data['assignedClientData'] is List<dynamic>) {
            list = data['assignedClientData'];
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
      print("Error get assigned clients: $e");
    }
    return null;
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

  // Future<dynamic> signupUser(String firstName, String lastName, String email,
  //     String password, String abn, String role) async {
  //   try {
  //     final checkEmailResponse =
  //         await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
  //     print('${_baseUrl}checkEmail/$email');
  //     final checkEmailData = json.decode(checkEmailResponse.body);
  //     switch (checkEmailResponse.statusCode) {
  //       case 200:
  //         print("checkEmail: ${checkEmailData['email']}");
  //         return null;
  //       case 400:
  //         print("email not found");
  //         final signupResponse = await http.post(
  //           Uri.parse('${_baseUrl}signup/$email'),
  //           headers: {
  //             "Content-Type": "application/json",
  //             "Accept": "application/json"
  //           },
  //           body: jsonEncode({
  //             "firstName": firstName,
  //             "lastName": lastName,
  //             "email": email,
  //             "password": password,
  //             "abn": abn,
  //             "role": role
  //           }),
  //         );
  //         print('${_baseUrl}signup/$email');
  //         switch (signupResponse.statusCode) {
  //           case 200:
  //             final signupData = json.decode(signupResponse.body);
  //             print("Signup successful: ${signupResponse.body}");
  //             return signupData;
  //           case 500:
  //             print("${signupResponse.statusCode}: ${signupResponse.body}");
  //             return null;
  //           default:
  //             print(
  //                 "Signup failed with status code ${signupResponse.statusCode}");
  //             return null;
  //         }
  //       case 500:
  //         print("Server error occurred");
  //         return null;
  //       default:
  //         print("Invalid response received");
  //         return null;
  //     }
  //   } on SocketException {
  //     print("Server error. Please retry");
  //     return null;
  //   }
  // }

  Future<dynamic> signupUser(String firstName, String lastName, String email,
      String password, String abn, String role) async {
    try {
      final checkEmailResponse =
          await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
      print('${_baseUrl}checkEmail/$email');

      switch (checkEmailResponse.statusCode) {
        case 200:
          print(
              "Email already exists: ${json.decode(checkEmailResponse.body)['email']}");
          return {"error": "Email already exists"};
        case 400: // Proceed with signup
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
            case 400:
              print(
                  "Signup failed: ${signupResponse.body}"); // Handle specific 400 errors
              return {"error": "Signup failed: ${signupResponse.body}"};
            case 409:
              print("Email already exists"); // Handle conflict
              return {"error": "Email already exists"};
            case 500:
              print("Server error: ${signupResponse.body}");
              return {"error": "Server error: ${signupResponse.body}"};
            default:
              print(
                  "Signup failed with status code ${signupResponse.statusCode}");
              return {
                "error":
                    "Signup failed with status code ${signupResponse.statusCode}"
              };
          }
        case 404:
          print("Invalid endpoint for checking email");
          return {"error": "Invalid endpoint for checking email"};
        case 500:
          print("Server error occurred");
          return {"error": "Server error occurred"};
        default:
          print("Invalid response received");
          return {"error": "Invalid response received"};
      }
    } on SocketException {
      print("Server error. Please retry");
      return {"error": "Server error. Please retry"};
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

  Future<List<String>> checkHolidaysSingle(List<String> workedDateList) async {
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

  Future<List<String>> checkHolidaysMultiple(
      List<List<String>> workedDateList) async {
    // Flatten the List<List<String>> to List<String>
    List<String> flattenedWorkedDateList =
        workedDateList.expand((i) => i).toList();
    return checkHolidaysSingle(flattenedWorkedDateList);
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

  Future<Uint8List?> getUserPhoto(
      String userEmail) async {
    final url = '${_baseUrl}getUserPhoto/$userEmail';
    print(url);
    final response = await http.get(Uri.parse(url));
    print("Get user photot: ${response.body} /n ${response.statusCode}");
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

  Future<Uint8List?> getUserPhotoFromFBS(PhotoData photoDataProvider) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("User not authenticated.");
        return null;
      } else {
        print("User authenticated.");
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics/${user.uid}.jpg');

        // Get the download URL of the stored file
        String downloadURL = await storageRef.getDownloadURL();

        // Use a network call or any method to fetch the image data
        // Here, I'm using http package to fetch the image data
        http.Response response = await http.get(Uri.parse(downloadURL));

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Decode the response body to Uint8List
          Uint8List imageData = response.bodyBytes;

          // Update the PhotoData change notifier
          photoDataProvider.updatePhotoData(imageData);

          return imageData;
        } else {
          print("Failed to fetch image: ${response.statusCode}");
          return null;
        }
      }
    } catch (error) {
      print('Error fetching profile picture: $error');
      return null;
    }
  }

  Future<UploadNotes> uploadNotes(
      String userEmail, String clientEmail, String notes) async {
    try {
      print("Email with notes: $userEmail + $notes");
      final response = await http.post(
        Uri.parse('${_baseUrl}addNotes/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "userEmail": userEmail,
          "clientEmail": clientEmail,
          "notes": notes,
        }),
      );
      print('${_baseUrl}uploadNotes/');
      if (response.statusCode == 200) {
        return UploadNotes(
          success: true,
          title: "Success",
          message: "Notes uploaded successfully",
          backgroundColor: AppColors.colorPrimary,
        );
      } else {
        return UploadNotes(
          success: false,
          title: "Error",
          message: "Notes upload failed",
          backgroundColor: AppColors.colorWarning,
        );
      }
    } on SocketException {
      throw Exception('Failed to upload notes: network error');
    } catch (e) {
      throw Exception('Failed to upload notes: $e');
    }
  }

  Future<Map<String, String>> addUpdateInvoicingEmailDetail(
    String userEmail,
    String invoicingBusinessName,
    String invoicingEmail,
    String invoicingEmailAppPassword,
  ) async {
    // try {
    EncryptDecrypt.generateEncryptionKey();
    final generatedKey = await EncryptDecrypt.getSecureEncryptionKey();
    print(
        "Generated key when calling addUpdateInvoicingEmailDetail is: $generatedKey");
    final encryptedPassword = EncryptDecrypt.encryptPassword(
        invoicingEmailAppPassword, generatedKey!);
    print("Encrypted password: $encryptedPassword");
    print("Hashed password with salt: $generatedKey");
    print('${_baseUrl}addUpdateInvoicingEmailDetail');
    final response = await http.post(
      Uri.parse('${_baseUrl}addUpdateInvoicingEmailDetail'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'userEmail': userEmail,
        'invoicingBusinessName': invoicingBusinessName,
        'email': invoicingEmail,
        'password': encryptedPassword
      },
    );

    print("gen code: $generatedKey");
    await http.post(
      Uri.parse('${_baseUrl}invoicingEmailDetailKey'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'userEmail': userEmail,
        'invoicingBusinessKey': generatedKey,
      },
    );

    print("Resp: ${response.statusCode}");

    Map<String, dynamic> data = {};

    switch (response.statusCode) {
      case 200:
        data = Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("200" + data['message']);
        }

        return {
          'message': 'Invoicing email details added successfully',
        };

      case 400:
        data = Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("400" + data['message']);
        }

        return {
          'message': 'Invoicing Email Details failed',
        };

      default:
        return {
          'message': 'Unknown error occurred',
        };
    }
    // } catch (e) {
    //   // Handle any exception that occurs during the adding email details process
    //   print("Exception api method: $e");
    //   return {
    //     'message': 'An error occurred during adding invoicing email details',
    //   };
    // }
  }

  Future<Map<String, dynamic>> getInvoicingEmailDetails(
      String email, String genKey) async {
    // try {
    final response = await http.get(
      Uri.parse('${_baseUrl}getInvoicingEmailDetails?email=$email'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    print("Respsss: ${response.body}");

    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("200" + data['message']);
        }
        print("Checking message: ${data['message']}");
        // Check if details exist in the response and return them
        if (data['message'] == 'Invoicing email details found') {
          final generatedKey = await EncryptDecrypt.getSecureEncryptionKey();
          print("Generated key is: $generatedKey");
          if (generatedKey == null) {
            if (genKey != null) {
              EncryptDecrypt.setSecureEncryptionKey(genKey);
            } else {
              return {
                'message': 'Encryption key not found',
              };
            }
          }
          print("Before $generatedKey $genKey");
          // Decrypt the password before returning the data
          final decryptedPassword = EncryptDecrypt.decryptPassword(
              data['password'], generatedKey ?? genKey);
          print("After $decryptedPassword");
          // Update the data map with the decrypted password
          data['password'] = decryptedPassword;
          print("DS: ${data.toString()}");
          return data;
        } else {
          return {
            'message': 'No invoicing email details found',
          };
        }

      case 400:
        Map<String, dynamic> errorData =
            Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("400" + errorData['message']);
        }

        return {
          'message': 'Error retrieving invoicing email details',
        };

      default:
        return {
          'message': 'Unknown error occurred',
        };
    }
    // } catch (e) {
    //   // Handle any exception that occurs during the retrieval process
    //   print("Exception in getInvoicingEmailDetails: $e");
    //   return {
    //     'message':
    //         'An error occurred during retrieving invoicing email details',
    //   };
    // }
  }

  Future<Map<String, dynamic>> checkInvoicingEmailKey(String email) async {
    // try {
    final response = await http.get(
      Uri.parse('${_baseUrl}checkInvoicingEmailKey?email=$email'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    print("checkInvoicingEmailKey: ${response.body}");

    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("200" + data['message']);
        }
        print("checkInvoicingEmailKey message: ${data['message']}");
        // Check if details exist in the response and return them
        if (data['message'] == 'Invoicing email key found') {
          debugPrint("Data key ${data['key']}");
          if (data['key'] == null) {
            return {
              'message': 'Encryption key empty',
            };
          }
          return data;
        } else {
          return {
            'message': 'No invoicing email key found',
          };
        }

      case 400:
        Map<String, dynamic> errorData =
            Map<String, dynamic>.from(json.decode(response.body));
        if (kDebugMode) {
          print("400" + errorData['message']);
        }

        return {
          'message': 'Error retrieving invoicing email key details',
        };

      default:
        return {
          'message': 'Unknown error occurred',
        };
    }
    // } catch (e) {
    //   // Handle any exception that occurs during the retrieval process
    //   print("Exception in getInvoicingEmailDetails: $e");
    //   return {
    //     'message':
    //         'An error occurred during retrieving invoicing email details',
    //   };
    // }
  }

  Future<Map<String, dynamic>> getEmailDetailToSendEmail(
      String userEmail) async {
    try {
      debugPrint(
          "getEmailDetailToSendEmail: $userEmail Uri.parse('${_baseUrl}getEmailDetailToSendEmail')");
      final response = await http.post(
        Uri.parse('${_baseUrl}getEmailDetailToSendEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': userEmail}),
      );
      debugPrint("getEmailDetails: ${response.body}");
      if (response.statusCode == 200) {
        final emailDetails = json.decode(response.body);
        if (emailDetails['message'] == 'No user found') {
          return {'Error': 'No user found'};
        } else if (emailDetails['message'] == 'No user found') {
          return {'Error': 'Internal server error'};
        } else {
          return {
            'accessToken': emailDetails['accessToken'],
            'emailAddress': emailDetails['emailAddress'],
            'recipientEmail': emailDetails['recipientEmail'],
          };
        }
      } else if (response.statusCode == 500) {
        debugPrint("Internal server error");
        return {'Error': 'Internal server error'};
      } else {
        debugPrint("Failed to load email details");
        throw Exception('Failed to load email details');
      }
    } catch (e) {
      print('Failed to get email details: $e');
      return {'Error': 'Failed to get email details'};
    }
  }
}
