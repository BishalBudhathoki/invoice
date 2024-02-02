import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/core/view-models/addBusiness_detail_model.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/views/popupClientDetails.dart';
import 'package:MoreThanInvoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/textField_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';

class AddBusinessDetails extends StatefulWidget {
  const AddBusinessDetails({super.key});

  @override
  _AddBusinessDetailsState createState() => _AddBusinessDetailsState();
}

class _AddBusinessDetailsState extends State<AddBusinessDetails> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final textVisibleNotifier = ValueNotifier<bool>(true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Add Business Details',
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business name';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business email';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business Phone',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business phone';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business Address',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business address';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business City',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business city';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business State',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business state';
                }
                return null;
              },
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
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Business Zip',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business zip';
                }
                return null;
              },
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
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                      popUpClientDetails(
                          _scaffoldKey.currentContext!, "success", "Business");
                    } else {
                      print('Error at business adding');
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                      popUpClientDetails(
                          _scaffoldKey.currentContext!, "error", "Business");
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

  ApiMethod apiMethod = ApiMethod();
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
