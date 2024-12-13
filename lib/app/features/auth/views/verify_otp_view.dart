import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/verify_otp_viewmodel.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:MoreThanInvoice/app/features/auth/views/change_password_view.dart';

import 'login_view.dart';

class VerifyOTPView extends StatelessWidget {
  final String otpGenerated;
  final String encryptVerificationKey;

  const VerifyOTPView({
    super.key,
    required this.otpGenerated,
    required this.encryptVerificationKey,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VerifyOTPViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: context.height * 0.023),
                const Text(
                  'Verify OTP!',
                  style: TextStyle(
                    color: AppColors.colorFontAccent,
                    fontSize: AppDimens.fontSizeXXMax,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: context.height * 0.023),
                const Text(
                  'Is this really you?',
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeNormal,
                    color: AppColors.colorFontPrimary,
                  ),
                ),
                SizedBox(height: context.height * 0.023),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: context.height * 0.03),
                    Pinput(
                      length: 6,
                      controller: viewModel.pinController,
                    ),
                    SizedBox(height: context.height * 0.03),
                    ButtonWidget(
                      title: 'Verify',
                      hasBorder: false,
                      onPressed: () async {
                        print('Verify button pressed');
                        await viewModel.verifyOTP(
                          viewModel.pinController.text,
                          otpGenerated,
                          encryptVerificationKey,
                          context,
                          (message) => showWarningDialog(
                              context, message), // Pass the callback
                        );

                        // Check if the OTP verification was successful
                        if (viewModel.response?['statusCode'] == 200) {
                          // Navigate to the Login view
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordView()), // Replace with your actual Login view
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
