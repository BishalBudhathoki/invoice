import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:argon2/argon2.dart';
import 'package:flutter/cupertino.dart';

class EncryptionUtils {
  static String? _encryptionKey;
  static String? get encryptionKey => _encryptionKey;

  static String generateEncryptionKey() {
    final random = Random.secure();
    final keyBytes = Uint8List(32); // Adjust the size of the key as needed
    for (var i = 0; i < keyBytes.length; i++) {
      keyBytes[i] = random.nextInt(256);
    }

    void setEncryptionKey(String key) {
      _encryptionKey = key;
    }

    final base64Key = (base64Url.encode(keyBytes)).substring(0, 16);
    setEncryptionKey(base64Key);

    // Ensure a fixed length for the key (e.g., 32 characters)
    return base64Key;
  }

  Uint8List generateSalt({int length = 32}) {
    debugPrint("generateSalt called");
    var random = Random.secure();
    return Uint8List.fromList(
        List.generate(length, (_) => random.nextInt(256)));
  }

  String encryptPasswordWithArgon2andSalt(String password, Uint8List salt) {
    debugPrint("encryptPasswordWithArgon2andSalt: $password $salt");
    // Hash the password with Argon2 using recommended parameters
    Uint8List salts = salt.isEmpty ? generateSalt() : salt;

    print("salttts: $salts");
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      salts,
      version: Argon2Parameters.ARGON2_VERSION_10,
      iterations: 2,
      memoryPowerOf2: 16,
    );
    print('Parameters: $parameters');

    var argon2 = Argon2BytesGenerator();

    argon2.init(parameters);

    var passwordBytes = parameters.converter.convert(password);

    print('Generating key from password...');

    var result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result, 0, result.length);

    var resultHex = result.toHexString();
    var saltHex = salts.toHexString();
    print('Result: $resultHex');
    print('Salt: $saltHex');
    // Combine hashed password and salt and store in the response
    var hashedPasswordWithSalt = '$resultHex$saltHex';
    print("hashedPasswordWithSalt: $hashedPasswordWithSalt");
    return hashedPasswordWithSalt;
  }

  Uint8List hexStringToUint8List(String hexString) {
    var bytes = <int>[];
    for (var i = 0; i < hexString.length; i += 2) {
      var hex = hexString.substring(i, i + 2);
      bytes.add(int.parse(hex, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
