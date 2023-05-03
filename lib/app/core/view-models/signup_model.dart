import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';

class SignupModel extends ChangeNotifier {
  // late String email;
  // late String password;
  // late String confirmPassword;
  // late String firstName;
  // late String lastName;
  // late String phoneNumber;
  // late String address;
  // late String city;
  // late String state;
  // late String zipCode;
  // late String country;
  // late String companyName;
  // late String companyAddress;
  // late String companyCity;
  // late String companyState;
  // late String companyZipCode;
  // late String companyCountry;
  // late String companyPhoneNumber;

  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _isValid = false;
  get isValid => _isValid;

  void isValidEmail(String input) {
    if (input == AssetsStrings.validEmail.first) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }

  void isValidPassword(String input, String text) {
    if (input == text) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }

  // SignupModel.fromJson(Map<String, dynamic> json) {
  //   email = json['email'];
  //   password = json['password'];
  //   confirmPassword = json['confirmPassword'];
  //   firstName = json['firstName'];
  //   lastName = json['lastName'];
  //   phoneNumber = json['phoneNumber'];
  //   address = json['address'];
  //   city = json['city'];
  //   state = json['state'];
  //   zipCode = json['zipCode'];
  //   country = json['country'];
  //   companyName = json['companyName'];
  //   companyAddress = json['companyAddress'];
  //   companyCity = json['companyCity'];
  //   companyState = json['companyState'];
  //   companyZipCode = json['companyZipCode'];
  //   companyCountry = json['companyCountry'];
  //   companyPhoneNumber = json['companyPhoneNumber'];
  // }
}
