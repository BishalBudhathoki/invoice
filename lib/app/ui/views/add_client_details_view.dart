import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/strings/appbar_title.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';

class AddClientDetails extends StatefulWidget {
  const AddClientDetails({super.key});

  @override
  _AddClientDetailsState createState() => _AddClientDetailsState();
}

class _AddClientDetailsState extends State<AddClientDetails> {
  final _formKey = GlobalKey<FormState>();
  final _clientFirstNameController = TextEditingController();
  final _clientLastNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientCityController = TextEditingController();
  final _clientStateController = TextEditingController();
  final _clientZipController = TextEditingController();

  @override
  void dispose() {
    _clientFirstNameController.dispose();
    _clientLastNameController.dispose();
    _clientEmailController.dispose();
    _clientPhoneController.dispose();
    _clientAddressController.dispose();
    _clientCityController.dispose();
    _clientStateController.dispose();
    _clientZipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AppBarTitle(
        title: "Add Client Details",
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFieldWidget(
              hintText: 'Client First Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter first name';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.person,
              suffixIconData: null,
              controller: _clientFirstNameController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientFirstNameController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Client Last Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter last name';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.person,
              suffixIconData: null,
              controller: _clientLastNameController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientLastNameController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client email';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.email,
              suffixIconData: null,
              controller: _clientEmailController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientEmailController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Phone',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client phone';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.phone_android,
              suffixIconData: null,
              controller: _clientPhoneController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientPhoneController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Address',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client address';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_on,
              suffixIconData: null,
              controller: _clientAddressController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientAddressController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'City',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client city';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _clientCityController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientCityController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'State',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client state';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _clientStateController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientStateController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Zip',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client zip';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _clientZipController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientZipController.text = value!;
              },
            ),
            const SizedBox(height: 16),
            ButtonWidget(
                title: 'Add Client',
                hasBorder: false,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showAlertDialog(context);
                    Future.delayed(const Duration(seconds: 3), () async {
                      final response = await _addClient();

                      if (response == "success") {
                        print('Add button pressed');
                        Navigator.of(context, rootNavigator: true).pop();
                      } else {
                        print('Error at client adding');
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  ApiMethod apiMethod = new ApiMethod();
  Future<dynamic> _addClient() async {
    var ins = await apiMethod.addClient(
      _clientFirstNameController.text,
      _clientLastNameController.text,
      _clientEmailController.text,
      _clientPhoneController.text,
      _clientAddressController.text,
      _clientCityController.text,
      _clientStateController.text,
      _clientZipController.text,
    );
    print("Response: " + ins.toString());

    if (ins['message'] == 'success') {
      if (kDebugMode) {
        print("Client added Successful ");
      }
      return ins['message'];
    } else {
      if (kDebugMode) {
        print("Client added Failed");
      }
      print("INS: " + ins);
      return ins['message'];
    }
  }
}
