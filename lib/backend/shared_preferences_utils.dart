import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  SharedPreferences? _sharedPreferences;
  SharedPreferences? get sharedPreferences => _sharedPreferences;

  SharedPreferencesUtils(); // Constructor

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences?.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _sharedPreferences?.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _sharedPreferences?.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _sharedPreferences?.setStringList(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }

  double? getDouble(String key) {
    return _sharedPreferences?.getDouble(key);
  }

  List<String>? getStringList(String key) {
    return _sharedPreferences?.getStringList(key);
  }

  Future<bool> containsKey(String key) async {
    return _sharedPreferences!.containsKey(key);
  }

  Future<void> remove(String key) async {
    await _sharedPreferences?.remove(key);
  }

  Future<void> clear() async {
    await _sharedPreferences?.clear();
  }

  Future<String?> getUserEmailFromSharedPreferences() async {
    return _sharedPreferences?.getString('user_email');
  }

  Future<void> saveEmailToSharedPreferences(String email) async {
    await _sharedPreferences?.setString('user_email', email);
  }

  void savePhoto(Uint8List photo) async {
    print("Photo data: $photo");

    // Convert Uint8List to base64-encoded string
    String photoString = base64Encode(photo);
    print("Photo data in savePhoto: $photoString");
    // Store the base64-encoded string in SharedPreferences
    await _sharedPreferences?.setString('photoKey', photoString);
  }

  Uint8List? getPhoto() {
    // Retrieve the base64-encoded string from SharedPreferences
    String? photoString = _sharedPreferences?.getString('photoKey');
    print("Photo string in getPhoto: $photoString");
    // Convert the base64-encoded string back to Uint8List
    Uint8List? photo = photoString != null ? base64Decode(photoString) : null;

    return photo;
  }
}
