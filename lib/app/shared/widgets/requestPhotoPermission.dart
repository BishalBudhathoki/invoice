import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();
Future<void> requestPhotoPermission() async {
  if (await checkAndRequestPhotosPermission() == false) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: const Text(
          "This app needs access to your photo library. Please enable the permission in the app settings.",
        ),
        action: SnackBarAction(
          label: "Open Settings",
          onPressed: () {
            openAppSettings();
          },
        ),
      ),
    );
  }
}

Future<bool> checkAndRequestPhotosPermission() async {
  if (Platform.isIOS) {
    debugPrint("In iOS platform storage permission asking:");

    PermissionStatus photosPermission = await Permission.photos.status;
    debugPrint("Current photo permission status: $photosPermission");

    if (photosPermission == PermissionStatus.denied ||
        photosPermission == PermissionStatus.permanentlyDenied) {
      photosPermission = await Permission.photos.request();
      debugPrint("Photo permission requested, new status: $photosPermission");

      if (photosPermission == PermissionStatus.permanentlyDenied) {
        // Permission is permanently denied, inform the user and guide them to settings
        bool isOpened = await openAppSettings();
        if (isOpened) {
          debugPrint("Opened app settings for permission.");
        } else {
          debugPrint("Failed to open app settings.");
        }
        return false;
      }
    }

    return photosPermission == PermissionStatus.granted;
  }

  return false; // If not iOS, return false or handle accordingly
}
