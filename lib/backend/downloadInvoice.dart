import 'dart:io';
import 'package:MoreThanInvoice/main.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadFiles(List<String> pdfPaths) async {
  print("Download files executed");
  var perm = await requestStoragePermission();
  print("Perm: $perm");
  if (perm) {
    const storage = FlutterSecureStorage();
    final downloadsDirectory = await getDownloadPathForPlatform();

    // Create a ZIP encoder
    final encoder = ZipFileEncoder();
    final zipFilePath = '$downloadsDirectory/invoices.zip';
    encoder.create(zipFilePath);

    for (String pdfPath in pdfPaths) {
      final file = File(pdfPath);
      final fileName = file.path.split('/').last;
      print("fileName: $fileName");

      try {
        final data = await file.readAsBytes();
        encoder.addFile(file);
      } on PlatformException catch (e) {
        print("Error while adding file to ZIP: $e");
      } catch (e) {
        print("Error while adding file to ZIP: $e");
      }
    }

    encoder.close();

    try {
      await Share.shareXFiles(
        [XFile(zipFilePath, mimeType: 'application/zip')],
        subject: 'Invoices',
      );
    } on PlatformException catch (e) {
      print("Error while sharing ZIP file: $e");
    } catch (e) {
      print("Error while sharing ZIP file: $e");
    }
  }
}

Future<String> getDownloadPathForPlatform() async {
  Directory? directory;
  print("Platform: ${Platform.operatingSystem}");
  try {
    if (Platform.isIOS) {
      print("iOS2");
      //String? appDocPath;
      try {
        directory = await getApplicationDocumentsDirectory();
      } catch (err) {
        print('Error while getting app directory path: $err');
      }
    } else if (Platform.isAndroid) {
      print("Android2");
      directory = Directory('/data/user/0/Download');
      await directory.exists() ? "Exists" : "Doesn't Exist";
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else if (kIsWeb) {
      print("Web2");
      directory = await getDownloadsDirectory();
    }
  } catch (err) {
    print("Cannot get download folder path");
  }
  //print(directory?.path);
  return directory!.path;
}

Future<bool> requestStoragePermission() async {
  List<Permission> permissions = [
    Permission.storage,
  ];

  int sdkInt;
  try {
    sdkInt = await mediaStorePlugin.getPlatformSDKInt();
  } catch (e) {
    print("Error getting SDK Int: $e");
    sdkInt = 0; // Fallback value if the method is not implemented
  }

  if (sdkInt >= 33) {
    permissions.add(Permission.photos);
  }

  if (Platform.isIOS) {
    debugPrint("In iOS platform storage permission asking:");

    PermissionStatus photosPermission = await Permission.storage.request();
    debugPrint("Current photo permission status: $photosPermission");

    if (photosPermission == PermissionStatus.denied ||
        photosPermission == PermissionStatus.permanentlyDenied) {
      photosPermission = await Permission.photos.request();
      debugPrint("Photo permission requested, new status: $photosPermission");

      if (photosPermission == PermissionStatus.permanentlyDenied) {
        final PermissionStatus storageStatus = await Permission.storage.status;

        if (storageStatus.isGranted) {
          // Permission already granted, proceed with storage access
          print('Storage permission granted');
          // Your code for accessing storage goes here
        } else if (storageStatus.isDenied) {
          // Request permission
          final PermissionStatus requestResult =
              await Permission.storage.request();
          if (requestResult == PermissionStatus.granted) {
            print('Storage permission granted after request');
            // Your code for accessing storage goes here
          } else if (requestResult == PermissionStatus.permanentlyDenied) {
            // Handle permanently denied case (iOS specific)
            await openAppSettings(); // Open app settings to guide user for manual permission grant
          } else if (requestResult == PermissionStatus.restricted) {
            // Handle restricted case (less common)
            print('Storage permission restricted');
          }
        } else if (storageStatus.isRestricted) {
          // Handle restricted case (less common)
          print('Storage permission restricted');
        }
      }
    }

    return photosPermission == PermissionStatus.granted;
  } else if (sdkInt >= 30) {
    PermissionStatus permission = await Permission.manageExternalStorage.status;
    print("Perm stat: $permission");
    if (permission != PermissionStatus.granted) {
      permission = await Permission.manageExternalStorage.request();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
  } else {
    PermissionStatus readPermission = await Permission.storage.status;
    if (readPermission != PermissionStatus.granted) {
      readPermission = await Permission.storage.request();
      if (readPermission != PermissionStatus.granted) {
        return false;
      }
    }
  }

  return true;
}
