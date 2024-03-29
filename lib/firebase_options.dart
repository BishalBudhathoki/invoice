// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDmveSTvv3bhV441a2vANKYKSwlvkn3Ww',
    appId: '1:406509736623:web:d15ae6e84d22b9d36a3a5a',
    messagingSenderId: '406509736623',
    projectId: 'invoice-660f3',
    authDomain: 'invoice-660f3.firebaseapp.com',
    storageBucket: 'invoice-660f3.appspot.com',
    measurementId: 'G-23F20R509G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAa1yMtafkB4jqE210h5ucbTe_LczG5MwM',
    appId: '1:406509736623:android:73088e652df1e5346a3a5a',
    messagingSenderId: '406509736623',
    projectId: 'invoice-660f3',
    storageBucket: 'invoice-660f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBN8LUmEnTFVxMiT422mOVWoBFtS8298Gw',
    appId: '1:406509736623:ios:80ba46b45d8930db6a3a5a',
    messagingSenderId: '406509736623',
    projectId: 'invoice-660f3',
    storageBucket: 'invoice-660f3.appspot.com',
    iosBundleId: 'com.bishal.invoice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBN8LUmEnTFVxMiT422mOVWoBFtS8298Gw',
    appId: '1:406509736623:ios:80ba46b45d8930db6a3a5a',
    messagingSenderId: '406509736623',
    projectId: 'invoice-660f3',
    storageBucket: 'invoice-660f3.appspot.com',
    iosBundleId: 'com.bishal.invoice',
  );
}
