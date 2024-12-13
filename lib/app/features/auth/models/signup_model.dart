import 'dart:core';
import 'package:MoreThanInvoice/app/core/base/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignupModel extends ChangeNotifier implements VisibilityToggleModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isVisible = false;
  bool _isValid = false;

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
    notifyListeners();
  }

  void isValidPassword(String input, String confirmPassword) {
    _isValid = input == confirmPassword;
    notifyListeners();
  }

  @override
  late bool isVisible1;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}