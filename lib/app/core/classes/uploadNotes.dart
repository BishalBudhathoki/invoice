import 'dart:ui';

class UploadNotes {
  final bool success;
  final String title;
  final String message;
  final Color backgroundColor;

  UploadNotes({
    required this.success,
    required this.title,
    required this.message,
    required this.backgroundColor,
  });
}
