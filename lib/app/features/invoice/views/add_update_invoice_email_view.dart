import 'package:MoreThanInvoice/app/features/invoice/viewmodels/update_invoice_email_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/auth/models/forgotPassword_model.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/alertDialog_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/busineess/models/addBusiness_detail_model.dart';
import 'package:MoreThanInvoice/app/shared/widgets/popupClientDetails.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:provider/provider.dart';

class AddUpdateInvoicingEmailView extends StatefulWidget {
  final String email;
  const AddUpdateInvoicingEmailView(this.email, String generatedKey,
      {super.key});

  @override
  _AddUpdateInvoicingEmailViewState createState() =>
      _AddUpdateInvoicingEmailViewState();
}

class _AddUpdateInvoicingEmailViewState
    extends State<AddUpdateInvoicingEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final UpdateInvoiceEmailViewModel
      _addUpdateInvoicingEmailViewController =
      UpdateInvoiceEmailViewModel();
  final _invoicingBusinessNameController = TextEditingController();
  final _invoicingBusinessEmailController = TextEditingController();
  final _invoicingBusinessEmailPasswordController = TextEditingController();

  @override
  void dispose() {
    _invoicingBusinessNameController.dispose();
    _invoicingBusinessEmailController.dispose();
    _invoicingBusinessEmailPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<ForgotPasswordModel>(context);
    final textVisibleNotifier = ValueNotifier<bool>(false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Add Invoicing Email Details',
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
              hintText: 'Admin\'s Business Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter admin\'s business name';
                }
                return null;
              },
              prefixIconData: Icons.person_2_outlined,
              suffixIconData: null,
              controller: _invoicingBusinessNameController,
              onChanged: (value) {},
              onSaved: (value) {
                _invoicingBusinessNameController.text = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget<ForgotPasswordModel>(
              suffixIconClickable: false,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Email',
              prefixIconData: Icons.mail_outline,
              suffixIconData: model.isValid ? Icons.check : null,
              controller: _invoicingBusinessEmailController,
              onChanged: (value) {
                model.isValidEmail(value);
              },
              onSaved: (value) {
                _invoicingBusinessEmailController.text = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                } else {
                  if (!model.isValid) {
                    return 'Please enter valid email';
                  }
                }
                return null;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            TextFieldWidget<AddBusinessDetailModel>(
              suffixIconClickable: true,
              obscureTextNotifier: textVisibleNotifier,
              hintText: 'Email\'s App Password',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter email app password';
                }
                return null;
              },
              prefixIconData: Icons.password_sharp,
              suffixIconData:
                  model.isVisible ? Icons.visibility : Icons.visibility_off,
              controller: _invoicingBusinessEmailPasswordController,
              onChanged: (value) {},
              onSaved: (value) {
                _addUpdateInvoicingEmailViewController.email = value!;
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const SizedBox(height: 16),
            ButtonWidget(
              title: 'Add Details',
              hasBorder: false,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showAlertDialog(context);
                  Future.delayed(const Duration(seconds: 3), () async {
                    final response =
                        await _addInvoicingEmailDetails(widget.email);

                    if (response ==
                        'Invoicing email details added successfully') {
                      print('Add button pressed');
                      Navigator.pop(_scaffoldKey.currentContext!);
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                      popUpClientDetails(_scaffoldKey.currentContext!,
                          "Success", "Invoicing email");
                    } else {
                      print('Error at business adding');
                      Navigator.pop(_scaffoldKey.currentContext!);
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                      popUpClientDetails(_scaffoldKey.currentContext!, "Error",
                          "Invoicing email");
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
  Future<dynamic> _addInvoicingEmailDetails(String email) async {
    var ins = await apiMethod.addUpdateInvoicingEmailDetail(
        email,
        _invoicingBusinessNameController.text,
        _invoicingBusinessEmailController.text,
        _invoicingBusinessEmailPasswordController.text);
    print("Response: $ins");

    if (ins['message'] == 'Invoicing email details added successfully') {
      if (kDebugMode) {
        print("Details added Successful ");
      }
      return ins['message'];
    } else {
      if (kDebugMode) {
        print("Details added Failed");
      }
      //print("INS: " + ins);
      return ins['message'];
    }
  }
}
