import 'package:MoreThanInvoice/app/core/base/base_model.dart';
import 'package:flutter/material.dart';

class VisibilityToggleModelImpl extends ChangeNotifier
    implements VisibilityToggleModel {
  bool _isVisible = false;
  bool _isVisible1 = false;

  @override
  bool get isVisible => _isVisible;

  @override
  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  @override
  bool get isVisible1 => _isVisible1;

  @override
  set isVisible1(bool value) {
    _isVisible1 = value;
    notifyListeners();
  }
}
