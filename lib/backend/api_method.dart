import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:invoice/backend/apiResponse.dart';

class ApiMethod {
//API to authenticate user login
  //String _baseUrl = "http://192.168.20.6:9001/";
  String _baseUrl = "https://backend-rest-apis.herokuapp.com/";
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
          print("400");
          break;
      }
    } on SocketException {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry") as String;
    }
    return data;
  }
  late Map<String, dynamic> data = {};
  Future<dynamic> checkEmail(String email) async {

    try {
      print('${_baseUrl}checkEmail/$email');
      //post method with body
      final response = await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
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

    try {
      print('${_baseUrl}login/$email/$password');
      //post method with body
      final response = await http.get(Uri.parse('${_baseUrl}login/$email/$password'));
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

  Future<dynamic> signupUser(
      String firstName,
      String lastName,
      String email,
      String password,

      ) async {
    // ApiResponse _apiResponse = new ApiResponse();

    try {
      print('${_baseUrl}checkEmail/$email');
      //post method with body
      final response = await http.get(Uri.parse('${_baseUrl}checkEmail/$email'));
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


    if( data['email'] == "Email not found") {
      try {
        print("Print me: " + data['email'] + " " + email);

          final response1 = await http.post(
            Uri.parse('${_baseUrl}signup/$email'),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonEncode({
              "firstName": firstName,
              "lastName": lastName,
              "email": email,
              "password": password
            }),
          );
          print(response1.body);
          switch (response1.statusCode) {
            case 200:
              data = new Map<String, dynamic>.from(json.decode(response1.body));
              print("200" + data['email']!);
              break;
          }

      } catch (e) {
        print(e);
      }
    }
    else{
      print("Email already exists");
    }

    return data;
  }

}