import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/base/base_model.dart';

class InvoicingEmailModel extends ChangeNotifier
    implements VisibilityToggleModel {
  bool _isVisible = false;
  @override
  get isVisible => _isVisible;

  @override
  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _isVisible1 = false;
  @override
  get isVisible1 => _isVisible1;

  @override
  set isVisible1(value) {
    _isVisible1 = value;
    notifyListeners();
  }

  bool _isValid = false;
  get isValid => _isValid;
}
