import 'dart:io';
import 'package:MoreThanInvoice/main.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class DownloadService {
  Future<String> downloadFiles(List<String> pdfPaths) async {
    print("Download files executed");
    var perm = await requestStoragePermission();
    String zipFilePath = "";
    print("Perm: $perm");
    if (perm) {
      const storage = FlutterSecureStorage();
      final downloadsDirectory = await getDownloadPathForPlatform();

      // Create a ZIP encoder
      final encoder = ZipFileEncoder();
      zipFilePath = '$downloadsDirectory/invoices.zip';
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
    debugPrint("Zip file path: $zipFilePath");
    return zipFilePath;
  }

  Future<String> getDownloadPathForPlatform() async {
    Directory? directory;
    print("Platform: ${Platform.operatingSystem}");
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        directory = Directory('/data/user/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (kIsWeb) {
        directory = await getDownloadsDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
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
      PermissionStatus photosPermission = await Permission.storage.request();
      if (photosPermission == PermissionStatus.denied ||
          photosPermission == PermissionStatus.permanentlyDenied) {
        photosPermission = await Permission.photos.request();
        if (photosPermission == PermissionStatus.permanentlyDenied) {
          final PermissionStatus storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted) {
            print('Storage permission granted');
          } else if (storageStatus.isDenied) {
            final PermissionStatus requestResult = await Permission.storage.request();
            if (requestResult == PermissionStatus.granted) {
              print('Storage permission granted after request');
            } else if (requestResult == PermissionStatus.permanentlyDenied) {
              await openAppSettings();
            } else if (requestResult == PermissionStatus.restricted) {
              print('Storage permission restricted');
            }
          } else if (storageStatus.isRestricted) {
            print('Storage permission restricted');
          }
        }
      }
      return photosPermission == PermissionStatus.granted;
    } else if (sdkInt >= 30) {
      PermissionStatus permission = await Permission.manageExternalStorage.status;
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
}