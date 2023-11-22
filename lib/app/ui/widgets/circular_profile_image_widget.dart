import 'dart:typed_data';

import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final Uint8List? imageBytes;
  final double size;

  const CircularImage({
    super.key,
    this.imageBytes,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (imageBytes != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: MemoryImage(imageBytes!),
      );
    } else {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: const AssetImage('assets/icons/profile_placeholder.png'),
      );
    }
  }
}

