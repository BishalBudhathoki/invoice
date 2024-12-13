import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:provider/provider.dart';

class PhotoDisplayWidget extends StatefulWidget {
  final String email;
  @override
  final Key? key;

  const PhotoDisplayWidget({required this.email, this.key}) : super(key: key);

  @override
  _PhotoDisplayWidgetState createState() => _PhotoDisplayWidgetState();
}

class _PhotoDisplayWidgetState extends State<PhotoDisplayWidget> {
  Future<Uint8List?>? _photoFuture;
  ApiMethod apiMethod = ApiMethod();
  Uint8List? photoData;

  SharedPreferencesUtils prefs = SharedPreferencesUtils();
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    //photoData = await apiMethod.getUserPhoto(widget.email);
    // _photoFuture = photoData != null ? Future.value(photoData) : null;
    //final Uint8List? phtdata = photoData;
    // print("photo data in init: $phtdata");
    // if (phtdata != null) {
    //   prefs.setString('photo', phtdata.toString());
    // }
    //setState(() {}); // Trigger a rebuild after data is initialized
    apiMethod.getUserPhoto(widget.email).then((value) {
      setState(() {
        photoData = value;
        _photoFuture = photoData != null ? Future.value(photoData) : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("photo data in widget: $photoData");
    return Consumer<PhotoData>(
      builder: (context, photoDataProvider, _) {
        return FutureBuilder<Uint8List?>(
          future: _photoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/profile_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
              //Text('Error loading photo: ${snapshot.error}');
            } else {
              final Uint8List? photoData = snapshot.data;
              return Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: photoData != null
                        ? MemoryImage(photoData)
                        : const AssetImage(
                                'assets/icons/profile_placeholder.png')
                            as ImageProvider<Object>,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
