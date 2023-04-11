import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invoice/app/ui/shared/values/strings/asset_strings.dart';

class LoginModel extends ChangeNotifier {
  get isVisible => _isVisible;
  bool _isVisible = false;
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  get isVisible1 => _isVisible1;
  bool _isVisible1 = false;
  set isVisible1(value) {
    _isVisible1 = value;
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
}
