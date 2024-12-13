import 'dart:ui';

class SignupResult {
  final bool success;
  final String title;
  final String message;
  final Color backgroundColor;

  SignupResult({
    required this.success,
    required this.title,
    required this.message,
    required this.backgroundColor,
  });
}
