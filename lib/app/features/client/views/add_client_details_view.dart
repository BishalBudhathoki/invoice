import 'dart:async';

import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/alertDialog_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/businessNameDropDown_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/client/models/addClient_detail_model.dart';
import 'package:MoreThanInvoice/app/shared/widgets/popupClientDetails.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';

class AddClientDetails extends StatefulWidget {
  const AddClientDetails({super.key});

  @override
  _AddClientDetailsState createState() => _AddClientDetailsState();
}

class _AddClientDetailsState extends State<AddClientDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _clientFirstNameController = TextEditingController();
  final _clientLastNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientCityController = TextEditingController();
  final _clientStateController = TextEditingController();
  final _clientZipController = TextEditingController();
  final _clientBusinessNameController = TextEditingController();
  late String selectedBusinessName;
  List businessNameList = [];

  @override
  void initState() {
    super.initState();
    // apiMethod.getBusinessNameList();
  }

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
    _clientBusinessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textVisibleNotifier = ValueNotifier<bool>(true);
    AddClientDetailModel model = AddClientDetailModel();
    //late String selectedBusinessName;
    //print(apiMethod.getBusinessNameList());
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Add Client Details',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Client First Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter first name';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Client Last Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter last name';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client email';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Phone',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client phone';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Address',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client address';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'City',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client city';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'State',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client state';
                }
                return null;
              },
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
            TextFieldWidget<AddClientDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Zip',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter client zip';
                }
                return null;
              },
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _clientZipController,
              onChanged: (value) {},
              onSaved: (value) {
                _clientZipController.text = value!;
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: BusinessNameDropdown(
                onChanged: (selectedValue) {
                  // Do something with the selected value
                  _clientBusinessNameController.text = selectedValue;
                  print('Selected Business Name: $selectedValue');
                },
              ),
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
                        Navigator.of(_scaffoldKey.currentContext!,
                                rootNavigator: true)
                            .pop();
                        popUpClientDetails(
                            _scaffoldKey.currentContext!, "success", "Client");
                      } else {
                        print('Error at client adding');
                        Navigator.of(_scaffoldKey.currentContext!,
                                rootNavigator: true)
                            .pop();
                        popUpClientDetails(
                            _scaffoldKey.currentContext!, "error", "Client");
                      }
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  ApiMethod apiMethod = ApiMethod();
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
      _clientBusinessNameController.text,
    );
    print("Response: $ins");

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
