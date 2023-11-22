import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/views/photo_display_widget.dart';
import 'package:invoice/app/ui/widgets/profile_placeholder_widget.dart';

class CustomAppBar extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;

  const CustomAppBar({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final double toolbarHeight = MediaQuery.of(context).size.height * 0.1;
    const double avatarRadius = 30.0; // Adjust the radius value
    const double endSpacing = 20.0; // Adjust the spacing value
    const double topSpacing = 10.0; // Adjust the spacing value

    return AppBar(
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0, // Add this line to remove the default spacing
      title: Row(
        children: [
          SizedBox(
            width: context.width * 0.042,
          ),
          ProfilePlaceholder(
            firstName: firstName,
            lastName: lastName,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: endSpacing, top: topSpacing),
          child: CircleAvatar(
            radius: avatarRadius, // Adjust the radius value here
            child: ClipOval(
              child: CircleAvatar(
                radius: avatarRadius, // Adjust the radius value here
                child: PhotoDisplayWidget(key: UniqueKey(), email: email),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
