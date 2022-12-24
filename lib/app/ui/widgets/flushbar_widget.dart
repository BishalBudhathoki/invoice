import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarWidget {
  Flushbar flushBar({
    required BuildContext context,
    required String title,
    required String message,
    // required IconData icon,
    required Color backgroundColor,
  }) {
   return Flushbar(
      icon: Icon(
        Icons.email_outlined,
        color: Colors.white,
        size: 30,
      ),

      backgroundColor: backgroundColor,
      duration: Duration(seconds: 4),
      message: message,
      messageSize: 18,
      titleText: Text(title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold,
              color: Colors.white)),
    )..show(context);
  }

}