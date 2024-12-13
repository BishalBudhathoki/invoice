import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/stream/chacha20.dart';

class EncryptDecrypt {
  static const _storage = FlutterSecureStorage();
  static String? _encryptionKey;

  static const _keyStorageKey = 'my_secure_key';

  static Future<String?> generateEncryptionKey({int length = 32}) {
    final random = Random.secure(); // Use secure random generator
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    final key = setSecureEncryptionKey(
        base64UrlEncode(values)); // Encode as Base64 for readability
    debugPrint('Generated Key for encryption is : $key');
    return key; // Encode as Base64 for readability
  }

  static Future<String?> setSecureEncryptionKey(String key) async {
    await _storage.write(key: 'encryption_key', value: key);
    return getSecureEncryptionKey();
  }

  static Future<String?> getSecureEncryptionKey() async {
    return await _storage.read(key: 'encryption_key');
  }

  static String encryptPassword(String password, String key) {
    final keyBytes = utf8.encode(key);
    final plainText = utf8.encode(password);

    final keyParam = KeyParameter(keyBytes);
    final params = ParametersWithIV(keyParam, Uint8List(8));

    final cipher = ChaCha20Engine();
    cipher.init(true, params);

    final encryptedBytes = cipher.process(Uint8List.fromList(plainText));
    final encrypted = base64Encode(encryptedBytes);
    print(
        "Before password: $password and before key: $key\n Encrypted Password: $encrypted and Key: $key");
    return encrypted;
  }

  // static String decryptPassword(String encryptedPassword, String key) {
  //   print("Encrypted Passwordss: $encryptedPassword and Keyss: $key");
  //   final keyBytes = utf8.encode(key);
  //   final encryptedBytes = base64Decode(encryptedPassword);
  //
  //   final keyParam = KeyParameter(keyBytes);
  //   final params = ParametersWithIV(keyParam, Uint8List(8));
  //
  //   final cipher = ChaCha20Engine();
  //   cipher.init(false, params);
  //
  //   final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
  //   return utf8.decode(decryptedBytes);
  // }

  static String decryptPassword(String encryptedPassword, String key) {
    print("Encrypted Passwordss: $encryptedPassword and Keyss: $key");
    final keyBytes = utf8.encode(key);
    final encryptedBytes = base64Decode(encryptedPassword);

    final keyParam = KeyParameter(keyBytes);
    final params = ParametersWithIV(keyParam, Uint8List(8));

    final cipher = ChaCha20Engine();
    cipher.init(false, params);

    final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
    try {
      debugPrint('Decrypted Password: ${utf8.decode(decryptedBytes)}');
      return utf8.decode(decryptedBytes);
    } catch (e) {
      print('Error decoding decrypted bytes: $e');
      return '';
    }
  }
}
