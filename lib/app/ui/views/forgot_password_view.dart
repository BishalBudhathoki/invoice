import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/controllers/forgotPassword_controller.dart';
import 'package:invoice/app/core/view-models/forgotPassword_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/views/verifyOTP_view.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:invoice/backend/encryption_utils.dart';
import 'package:invoice/backend/shared_preferences_utils.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordControllerState();
  }
}

class _ForgotPasswordControllerState extends State<ForgotPasswordView> {
  final _userEmailController = TextEditingController();
  final ForgotPasswordController forgotPasswordController =
      ForgotPasswordController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    _sub = uriLinkStream.listen((Uri? uri) {
      // Handle link
      if (uri != null) {
        String? code = uri.queryParameters['oobCode'];

        // Use code here
      }
    }, onError: (err) {});
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<ForgotPasswordModel>(context);
    final textVisibleNotifier = ValueNotifier<bool>(false);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.colorWhite,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(AppDimens.padding),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  SizedBox(height: context.height * 0.023),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.colorFontAccent,
                      fontSize: AppDimens.fontSizeXXMax,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: context.height * 0.023),
                  const Text(
                    'Lets get your account back!',
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeNormal,
                      color: AppColors.colorFontPrimary,
                    ),
                  ),
                  SizedBox(height: context.height * 0.023),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        TextFieldWidget<ForgotPasswordModel>(
                          suffixIconClickable: false,
                          obscureTextNotifier: textVisibleNotifier,
                          hintText: 'Email',
                          prefixIconData: Icons.mail_outline,
                          suffixIconData: model.isValid ? Icons.check : null,
                          controller: _userEmailController,
                          onChanged: (value) {
                            model.isValidEmail(value);
                          },
                          onSaved: (value) {
                            forgotPasswordController.email = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ButtonWidget(
                          title: 'Get OTP',
                          hasBorder: false,
                          onPressed: () async {
                            if (_userEmailController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Warning',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    content: Text('Email field is empty.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    actions: [
                                      TextButton(
                                        child: Text('OK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the warning dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            //showAlertDialog(context);

                            if (kDebugMode) {
                              print('Get OTP button pressed');
                            }
                            var currentContext =
                                context; // Capture the current context
                            Timer timer = Timer(const Duration(seconds: 8), () {
                              // Display warning after 3 seconds (adjust the duration as needed)
                              Navigator.of(context).pop(); // Close the dialog

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Warning',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    content: Text(
                                        'OTP process is taking longer than expected.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    actions: [
                                      TextButton(
                                        child: Text('OK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the warning dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            });

                            var response = await _handleSubmitted(context);
                            print("Response: ${response['otp']}");
                            timer.cancel(); // Cancel the timer

                            if (response.containsKey('statusCode')) {
                              if (response['statusCode'] == 200) {
                                Navigator.push(
                                  _scaffoldKey.currentContext!,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyOTPView(
                                      otpGenerated: "${response['otp']}",
                                      encryptVerificationKey:
                                          "${response['verificationKey']}",
                                    ),
                                  ),
                                );
                              } else if (response['statusCode'] == 500) {
                                showWarningDialog("Error Sending OTP!");
                              } else {
                                print('Error at Server');
                                showWarningDialog(
                                    "Error at getting your data!");
                                Navigator.of(_scaffoldKey.currentContext!,
                                        rootNavigator: true)
                                    .pop();
                              }
                            } else {
                              print('Error at Server');
                              Navigator.of(_scaffoldKey.currentContext!,
                                      rootNavigator: true)
                                  .pop();
                            }
                          },
                        ),
                      ]),
                ])))));
  }

  showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the column takes minimal space
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

  ApiMethod apiMethod = ApiMethod();
  Future<Map<String, dynamic>> _handleSubmitted(BuildContext context) async {
    try {
      final encryptionKey = EncryptionUtils.generateEncryptionKey();
      print('Generated Encryption Key: $encryptionKey');
      final prefsUtils =
          Provider.of<SharedPreferencesUtils>(context, listen: false);
      await prefsUtils
          .saveEmailToSharedPreferences(_userEmailController.text.trim());

      // Send password reset OTP email
      Map<String, dynamic> msg = await apiMethod.sendOTP(
          _userEmailController.text.trim(), encryptionKey);
      return msg;
    } catch (e, stackTrace) {
      print(e.toString());
      print(stackTrace.toString());

      // Catch any errors that might occur due to the context issue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((e).toString()),
        ),
      );
      // Return an error map with appropriate keys and values
      return {
        'statusCode': -1, // or another value indicating an error
        'message': e.toString(),
        'stackTrace': stackTrace.toString(),
      };
    }
  }
}
