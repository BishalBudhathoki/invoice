import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/strings/asset_strings.dart';

import 'Base_model.dart';

class ForgotPasswordModel extends ChangeNotifier
    implements VisibilityToggleModel {
  bool _isValid = false;
  get isValid => _isValid;

  void isValidEmail(String input) {
    final emailRegex = AssetsStrings.validEmailPattern;
    if (emailRegex.hasMatch(input)) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }

  bool _isVisible = false;
  @override
  get isVisible => _isVisible;

  @override
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  @override
  late bool isVisible1;
}
