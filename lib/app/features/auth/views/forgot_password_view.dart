import 'package:MoreThanInvoice/app/features/auth/views/verify_otp_view.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/features/auth/models/forgotPassword_model.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/forgot_password_viewmodel.dart';

import 'change_password_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Forgot Password',
        style: TextStyle(color: AppColors.colorFontSecondary),
      )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<ForgotPasswordViewModel>(
          builder: (context, forgotPasswordViewModel, child) {
            return Form(
              key: forgotPasswordViewModel.formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.023),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.colorFontAccent,
                      fontSize: AppDimens.fontSizeXXMax,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: size.height * 0.023),
                  const Text(
                    'Let\'s get your account back!',
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeNormal,
                      color: AppColors.colorFontPrimary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.023),
                  TextFieldWidget<ForgotPasswordModel>(
                    hintText: 'Email',
                    controller: forgotPasswordViewModel.model.emailController,
                    prefixIconData: Icons.mail_outline,
                    suffixIconData: forgotPasswordViewModel.model.isValid
                        ? Icons.check
                        : null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      forgotPasswordViewModel.model.isValidEmail(value);
                    },
                    onSaved: (value) {
                      forgotPasswordViewModel.model.emailController.text =
                          value!;
                    },
                    obscureTextNotifier: ValueNotifier<bool>(false),
                    suffixIconClickable: false,
                  ),
                  SizedBox(height: size.height * 0.023),
                  ButtonWidget(
                    title: 'Get OTP',
                    hasBorder: false,
                    onPressed: () async {
                      if (forgotPasswordViewModel
                          .model.emailController.text.isEmpty) {
                        forgotPasswordViewModel.showWarningDialog(
                            context, 'Email field is empty.');
                        return;
                      }

                      await forgotPasswordViewModel.resetPassword(context,
                          (response) {
                        // Navigate to ChangePasswordView on success
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            VerifyOTPView(
                              otpGenerated: forgotPasswordViewModel.otp!, // Pass the OTP
                              encryptVerificationKey: forgotPasswordViewModel.verificationKey!, // Pass the verification key), // Adjust this to your actual ChangePasswordView
                          ),
                        )
                        );
                      },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
