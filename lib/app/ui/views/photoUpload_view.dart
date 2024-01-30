import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/flushbar_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoUploadScreen extends StatefulWidget {
  String email;
  PhotoUploadScreen({super.key, required this.email});
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _imageFile;
  ApiMethod apiMethod = ApiMethod();
  final picker = ImagePicker();
  final imageCropper = ImageCropper();
  FlushBarWidget flushBarWidget = FlushBarWidget();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late Uint8List? updatedPhoto;

  Future<void> _pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var croppedPickedFile = await imageCropper.cropImage(
      sourcePath: pickedFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    //updatedPhoto = croppedPickedFile;
    // croppedPickedFile = await compressImage(croppedPickedFile?.path, 35);
    if (croppedPickedFile != null) {
      final bytes = await croppedPickedFile.readAsBytes(); // Read bytes here
      setState(() {
        _imageFile = File(croppedPickedFile.path);
        updatedPhoto = bytes; // Store Uint8List
      });
    } else {
      print('No image selected.');
      _imageFile = null;
    }
  }

  Future<bool> _uploadPhoto(BuildContext buildContext) async {
    try {
      if (_imageFile == null) {
        // No image selected
        print("No image selected.");
        return false;
      }

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      print('user: $user');
      if (user == null) {
        // User not authenticated
        print("User not authenticated.");
        return false;
      } else {
        print("User authenticated.");
        // Create a reference to the user's profile picture in Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics/${user.uid}.jpg');
        print("1");
        // Upload the file to Firebase Storage
        final response = await storageRef.putFile(_imageFile!);
        print("2:: ${response.toString()}");
        // Get the download URL of the uploaded file
        String downloadURL = await storageRef.getDownloadURL();

        // Update the user's profile with the download URL
        await user.updatePhotoURL(downloadURL);
        final photoDataProvider =
            Provider.of<PhotoData>(buildContext, listen: false);
        photoDataProvider.updatePhotoData(updatedPhoto!);
        return true;
      }
    } catch (error) {
      if (error is IOException) {
        // Check specific Firebase Storage error codes here
        print('Error uploading photo: $error');
        return false;
      }
      if (error is PlatformException) {
        // Check for permission-related error codes
        if (error.code == 'storage/unauthorized' ||
            error.code == 'storage/permission-denied' ||
            error.message!.contains('403')) {
          // Permission error handling
          print('Permission denied to upload profile picture.');
          return false;
        } else {
          // Handle other platform errors
          print('Platform error: ${error.code}');
          return false;
        }
      } else {
        // Handle other errors
        print('Error uploading photo: $error');
        return false;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Photo Upload',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                'You can upload a profile picture here, if photo access permission is not given already it might be asked.',
                style: TextStyle(
                  color: AppColors.colorFontPrimary,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Lato',
                ),
                maxLines: 2,
              ),
            ),
          ),
          if (_imageFile != null) ...[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Set the border color
                  width: 2.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(
                    8.0), // Set the border radius as needed
              ),
              child: Image.file(
                _imageFile!,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWidget(
                title: 'Upload Photo',
                hasBorder: false,
                onPressed: () => {
                  _uploadPhoto(_scaffoldKey.currentContext!).then((value) {
                    if (value) {
                      flushBarWidget.flushBar(
                        title: 'Upload Success!',
                        message: 'Profile picture uploaded successfully!',
                        backgroundColor: AppColors.colorSecondary,
                        context: _scaffoldKey.currentContext!,
                      );
                    } else {
                      flushBarWidget.flushBar(
                        title: 'Upload Failure.',
                        message: 'Error uploading profile picture.',
                        backgroundColor: AppColors.colorWarning,
                        context: _scaffoldKey.currentContext!,
                      );
                    }
                  })
                },
              ),
            ),
          ],
          if (_imageFile == null)
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.2759,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, // Set the border color
                    width: MediaQuery.of(context).size.width * 0.01),
                borderRadius: BorderRadius.circular(
                    8.0), // Set the border radius as needed
              ),
              child: Image.asset(
                'assets/icons/profile_placeholder.png',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.27,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ButtonWidget(
              title: 'Select Photo',
              onPressed: _pickImage,
              hasBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
