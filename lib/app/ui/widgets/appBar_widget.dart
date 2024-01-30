import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/views/photo_display_widget.dart';
import 'package:invoice/app/ui/widgets/profile_placeholder_widget.dart';

class CustomAppBar extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final Uint8List? photoData;

  const CustomAppBar({
    Key? key,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.photoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double toolbarHeight = MediaQuery.of(context).size.height * 0.1;
    const double avatarRadius = 30.0;
    const double endSpacing = 20.0;
    const double topSpacing = 5.0;

    return AppBar(
      //toolbarHeight: toolbarHeight + MediaQuery.of(context).padding.top,
      toolbarHeight: kToolbarHeight,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: ProfilePlaceholder(
              firstName: firstName,
              lastName: lastName,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: endSpacing, top: topSpacing),
          child:
              // CircleAvatar(
              //   radius: avatarRadius,
              //   child: ClipOval(
              //     child: CircleAvatar(
              //       radius: avatarRadius,
              //       child: PhotoDisplayWidget(key: UniqueKey(), email: email),
              //     ),
              //   ),
              // ),
              CircleAvatar(
            child: ClipOval(
              child: CircleAvatar(
                radius: 27.5,
                child: CircleAvatar(
                  radius: 27.5,
                  child:
                      // PhotoDisplayWidget(key: UniqueKey(), email: email),
                      Container(
                    key: UniqueKey(),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: photoData != null
                            ? MemoryImage(photoData!)
                            : const AssetImage(
                                    'assets/icons/profile_placeholder.png')
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
