import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/showWarningDiaglog_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/features/auth/models/changePassword_model.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/change_password_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/auth/views/login_view.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';

class ChangePasswordView extends StatelessWidget {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final changePasswordViewModel =
        Provider.of<ChangePasswordViewModel>(context);
    final _scafoldKey = GlobalKey();

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: SafeArea(
        key: _scafoldKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: changePasswordViewModel.formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height * 0.023),
                  const Text(
                    'Reset Password!',
                    style: TextStyle(
                      color: AppColors.colorFontAccent,
                      fontSize: AppDimens.fontSizeXXMax,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: size.height * 0.023),
                  const Text(
                    'You are.. you! Yay!!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.colorFontPrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.023),
                  TextFieldWidget<ChangePasswordModel>(
                    hintText: 'New Password',
                    controller: changePasswordViewModel.newPasswordController,
                    validator: (value) {
                      changePasswordViewModel.validatePasswords();
                    },
                    onChanged: (value) {
                      changePasswordViewModel.validatePasswords();
                    },
                    onSaved: (String) {},
                    obscureTextNotifier: ValueNotifier<bool>(changePasswordViewModel.model.isVisible),
                    suffixIconClickable: true,
                    prefixIconData: Icons.lock,
                    getSuffixIcon: (isVisible) => isVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),

                  SizedBox(height: size.height * 0.03),

                  TextFieldWidget<ChangePasswordModel>(
                    hintText: 'Confirm Password',
                    controller: changePasswordViewModel.confirmPasswordController,
                    validator: (value1) {
                      return changePasswordViewModel.validateConfirmPassword(value1);
                    },
                    onChanged: (value) {
                      changePasswordViewModel.validatePasswords();
                    },
                    onSaved: (String) {},
                    obscureTextNotifier: ValueNotifier<bool>(changePasswordViewModel.model.isVisible1),
                    suffixIconClickable: true,
                    prefixIconData: Icons.lock,
                    getSuffixIcon: (isVisible1) => isVisible1
                        ? Icons.visibility
                        : Icons.visibility_off,
                    confirmPasswordToggle: true,
                  ),
                  SizedBox(height: size.height * 0.03),
                  ValueListenableBuilder<String?>(
                    valueListenable: changePasswordViewModel.errorNotifier,
                    builder: (context, error, _) => Text(
                      error ?? '',
                      style: const TextStyle(color: AppColors.colorWarning),
                    ),
                  ),
                  //SizedBox(height: size.height * 0.03),
                  ButtonWidget(
                    title: 'Reset Password',
                    hasBorder: false,
                    onPressed: () async {
                      // if (key?.currentState.validate()) {
                        var response =
                            await changePasswordViewModel.changePassword(
                                changePasswordViewModel.newPasswordController.text,
                                changePasswordViewModel.confirmPasswordController.text,
                                context);
                        if (response != null &&
                            response.containsKey('message')) {
                          if (response['message'] ==
                              'Password updated successfully') {
                            DialogUtils.showWarningDialog(
                              context,
                              "Password updated successfully!",
                              "Success",
                              onOkPressed: () {
                                // Clear the navigation stack and navigate to LoginView
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const LoginView()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                            );
                          } else {
                            DialogUtils.showWarningDialog(
                              context,
                              "Updating password Failed!",
                              "Warning",
                            );
                          }
                        }
                      // }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
