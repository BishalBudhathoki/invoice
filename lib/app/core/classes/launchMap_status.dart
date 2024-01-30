import 'dart:ui';

class LaunchMapStatus {
  final bool success;
  final String title;
  final String message;
  final Color backgroundColor;

  LaunchMapStatus({
    required this.success,
    required this.title,
    required this.message,
    required this.backgroundColor,
  });
}
