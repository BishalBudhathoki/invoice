import 'dart:typed_data';
import 'package:flutter/material.dart';

class PhotoData extends ChangeNotifier {
  Uint8List? _photoData;

  Uint8List? get photoData => _photoData;

  void updatePhotoData(Uint8List? data) {
    _photoData = data;
    notifyListeners();
  }
}

