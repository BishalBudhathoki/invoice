import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Base_model.dart';

class ChangePasswordModel extends ChangeNotifier
    implements VisibilityToggleModel {
  bool _isVisible = false;
  bool _isVisible1 = false;

  bool _isValid = false;
  bool _isValid1 = false;

  bool _isFirstTextField = true;

  @override
  get isVisible => _isVisible;
  @override
  get isVisible1 => _isVisible1;

  get isValid => _isValid;
  get isValid1 => _isValid1;

  @override
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  @override
  set isVisible1(value) {
    _isVisible1 = value;
    notifyListeners();
  }

  bool get isFirstTextField => _isFirstTextField;

  set isFirstTextField(bool isFirstTextField) {
    _isFirstTextField = isFirstTextField;
    notifyListeners();
  }

  void isValidPassword(String input) {
    if (input.length >= 8) {
      _isValid = true;
      notifyListeners();
    } else {
      _isValid = false;
      notifyListeners();
    }
  }

  void isValidConfirmPassword(String input) {
    if (input.length >= 8) {
      _isValid1 = true;
    } else {
      _isValid1 = false;
    }
    notifyListeners();
  }
}
