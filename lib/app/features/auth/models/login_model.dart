import 'dart:core';
import 'package:MoreThanInvoice/app/core/base/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LoginModel extends ChangeNotifier implements VisibilityToggleModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isVisible = false;
  bool _isValid = false;
  IconData? suffixIconData;

  @override
  bool get isVisible => _isVisible;

  @override
  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  bool get isValid => _isValid;

  void isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    _isValid = emailRegex.hasMatch(input);
    suffixIconData = _isValid ? Icons.check : null;
    notifyListeners();
  }

  @override
  late bool isVisible1 = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
