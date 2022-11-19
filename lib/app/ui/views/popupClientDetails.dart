import 'package:flutter/material.dart';

  void popUpClientDetails(BuildContext context, String message, String title) {
    if(message == "success") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Result'),
            content: Text('Result  $message \n$title Details Added Successfully',
              style: const TextStyle(
                color: Colors.green,
                height: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Lato',
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16)))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            content: Text('Failed or data already added for $title',
              style: const TextStyle(
                color: Colors.red,
                height: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Lato',
              ),),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16)))
            ],
          );
        },
      );
    }
}