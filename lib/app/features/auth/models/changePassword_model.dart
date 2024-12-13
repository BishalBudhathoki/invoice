import 'dart:core';
import 'package:MoreThanInvoice/app/core/base/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChangePasswordModel extends ChangeNotifier
    implements VisibilityToggleModel {
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  get isVisible => _isNewPasswordVisible;
  @override
  get isVisible1 => _isConfirmPasswordVisible;


  @override
  set isVisible(value) {
    _isNewPasswordVisible = value;
    notifyListeners();
  }

  @override
  set isVisible1(value) {
    _isConfirmPasswordVisible = value;
    notifyListeners();
  }

}
