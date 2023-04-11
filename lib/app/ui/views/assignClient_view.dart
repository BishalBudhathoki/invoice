import 'package:flutter/material.dart';

class AssignClient extends StatefulWidget {
  const AssignClient({Key? key}) : super(key: key);

  @override
  _AssignClientState createState() => _AssignClientState();
}

class _AssignClientState extends State<AssignClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Client'),
      ),
      body: const Center(
        child: Text('Assign Client'),
      ),
    );
  }
}
