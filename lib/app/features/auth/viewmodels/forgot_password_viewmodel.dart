import 'package:MoreThanInvoice/app/shared/utils/encryption/encryption_utils.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/auth/models/forgotPassword_model.dart';
import 'package:provider/provider.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordModel model = ForgotPasswordModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final ApiMethod apiMethod = ApiMethod();

  String? otp; // Property to hold the OTP
  String? verificationKey; // Property to hold the verification key

  Future<void> resetPassword(
      BuildContext context, Function(Map<String, dynamic>) onSuccess) async {
    if (formKey.currentState!.validate()) {
      try {
        final encryptionKey = EncryptionUtils.generateEncryptionKey();
        print('Generated Encryption Key: $encryptionKey');
        final prefsUtils =
        Provider.of<SharedPreferencesUtils>(context, listen: false);
        await prefsUtils
            .saveEmailToSharedPreferences(model.emailController.text.trim());

        // Send password reset OTP email
        Map<String, dynamic> msg = await apiMethod.sendOTP(
            model.emailController.text.trim(), encryptionKey);
        print('Response: $msg');

        // Check the response and call the onSuccess callback if successful
        if (msg.containsKey('statusCode') && msg['statusCode'] == 200) {
          otp = msg['otp']; // Store the OTP
          verificationKey = msg['verificationKey']; // Store the verification key
          onSuccess(msg); // Call the callback with the response
        } else {
          showWarningDialog(context, "Error Sending OTP!");
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((e).toString()),
          ),
        );
      }
    }
  }

  showWarningDialog(BuildContext context, String message) {
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
                Navigator.of(context).pop(); // Close the warning dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    model.dispose(); // Dispose of the model's controllers
    super.dispose();
  }
}