import 'dart:convert';
import 'dart:typed_data';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:flutter/material.dart';

class PhotoData extends ChangeNotifier {
  Uint8List? _photoData;
  bool _isLoading = true;
  String? _currentEmail;

  Uint8List? get photoData => _photoData;
  bool get isLoading => _isLoading;

  Future<void> loadPhotoData(String email) async {
    if (_currentEmail == email && _photoData != null) return;
    _isLoading = true;
    _currentEmail = email;
    notifyListeners();

    try {
      final prefs = SharedPreferencesUtils();
      await prefs.init();

      // Try to get from local storage first
      Uint8List? localPhoto = await prefs.getPhoto();

      if (localPhoto != null) {
        _photoData = localPhoto;
      } else {
        // If not in local storage, fetch from API
        final apiMethod = ApiMethod();
        final fetchedPhoto = await apiMethod.getUserPhoto(email);

        if (fetchedPhoto != null) {
          _photoData = fetchedPhoto;
          await prefs.setPhoto(fetchedPhoto);
        }
      }
    } catch (e) {
      print('Error loading photo: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updatePhotoData(Uint8List? data) {
    _photoData = data;
    _isLoading = false;
    notifyListeners();
  }

  void clearPhoto() {
    _photoData = null;
    _currentEmail = null;
    _isLoading = false;
    notifyListeners();
  }
}
