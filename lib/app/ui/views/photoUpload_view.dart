import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/app/core/view-models/photoData_viewModel.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:provider/provider.dart';

class PhotoUploadScreen extends StatefulWidget {
  String email;
  PhotoUploadScreen({Key? key, required this.email}) : super(key: key);
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _imageFile;
  ApiMethod apiMethod = ApiMethod();
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
      _imageFile = null;
    }
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    if (_imageFile != null) {
      try {
        await apiMethod.uploadPhoto(context, widget.email.toString(), _imageFile!);
        print('Photo uploaded successfully!');

        final photoDataProvider = Provider.of<PhotoData>(context, listen: false);
        final Uint8List? photoData = await apiMethod.getUserPhoto(widget.email);
        photoDataProvider.updatePhotoData(photoData);
      } catch (e) {
        print('Error uploading photo: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo Upload',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) ...[
              Image.file(
                _imageFile!,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _uploadPhoto(context),
                child: const Text(
                  'Upload Photo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text(
                'Select Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

