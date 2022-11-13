import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/shared/values/strings/appbar_title.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';

class AddBusinessDetails extends StatefulWidget {
  const AddBusinessDetails({super.key});

  @override
  _AddBusinessDetailsState createState() => _AddBusinessDetailsState();
}

class _AddBusinessDetailsState extends State<AddBusinessDetails> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessCityController = TextEditingController();
  final _businessStateController = TextEditingController();
  final _businessZipController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _businessAddressController.dispose();
    _businessCityController.dispose();
    _businessStateController.dispose();
    _businessZipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AppBarTitle(title: "Add Business Details",),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFieldWidget(
              hintText: 'Business Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business name';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.person,
              suffixIconData: null,
              controller: _businessNameController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessNameController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Business Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business email';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.email,
              suffixIconData: null,
              controller: _businessEmailController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessEmailController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Business Phone',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business phone';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.phone,
              suffixIconData: null,
              controller: _businessPhoneController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessPhoneController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Business Address',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business address';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_on,
              suffixIconData: null,
              controller: _businessAddressController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessAddressController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Business City',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business city';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _businessCityController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessCityController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget(
              hintText: 'Business State',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business state';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _businessStateController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessStateController.text = value!;
              },
            ),
            SizedBox(
                height: size.height * 0.02,
              ),
            TextFieldWidget(
              hintText: 'Business Zip',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business zip';
                }
                return null;
              },
              obscureText: false,
              prefixIconData: Icons.location_city,
              suffixIconData: null,
              controller: _businessZipController,
              onChanged: (value) {},
              onSaved: (value) {
                _businessZipController.text = value!;
              },
            ),

            const SizedBox(height: 16),
            ButtonWidget(
              title: 'Add Business',
              hasBorder: false,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showAlertDialog(context);
                  Future.delayed(const Duration(seconds: 3), () async {
                    final response = await _addBusiness();

                    if (response == "success") {
                      print('Add button pressed');
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      print('Error at business adding');
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  ApiMethod apiMethod = new ApiMethod();
  Future<dynamic> _addBusiness() async {
    var ins = await apiMethod.addBusiness(
      _businessNameController.text,
      _businessEmailController.text,
      _businessPhoneController.text,
      _businessAddressController.text,
      _businessCityController.text,
      _businessStateController.text,
      _businessZipController.text,
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
