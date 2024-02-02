import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/strings/asset_strings.dart';

import 'Base_model.dart';

class SignupModel extends ChangeNotifier implements VisibilityToggleModel {
  @override
  get isVisible => _isVisible;
  bool _isVisible = false;
  @override
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _isValid = false;
  get isValid => _isValid;

  void isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailRegex.hasMatch(input)) {
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

  @override
  late bool isVisible1;

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
