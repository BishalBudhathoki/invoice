import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/controllers/changePassword_controller.dart';
import 'package:invoice/app/core/view-models/changePassword_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/views/login_view.dart';
import 'package:invoice/app/ui/widgets/bottom_navBar_widget.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/showWarningDiaglog_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:invoice/backend/encryption_utils.dart';
import 'package:invoice/backend/shared_preferences_utils.dart';
import 'package:provider/provider.dart';
import 'package:argon2/argon2.dart';
import 'dart:typed_data';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({
    super.key,
  });
//EncryptionUtils.encryptionKey,
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePasswordView> {
  final _initialNewPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _initialNewPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<ChangePasswordModel>(context);
    final ChangePasswordController changePasswordController =
        ChangePasswordController();
    final ChangePasswordController confirmChangePasswordController =
        ChangePasswordController();

// Create separate ValueNotifier instances for each TextFieldWidget
    final ValueNotifier<bool> passwordVisibleNotifier =
        ValueNotifier<bool>(true);
    final ValueNotifier<bool> confirmPasswordVisibleNotifier =
        ValueNotifier<bool>(true);
    ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
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
                    'Reset Password!',
                    style: TextStyle(
                      color: AppColors.colorFontAccent,
                      fontSize: AppDimens.fontSizeXXMax,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: context.height * 0.023),
                  const Text(
                    'You are.. you! Yay!!',
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
                        TextFieldWidget<ChangePasswordModel>(
                          suffixIconClickable: true,
                          hintText: 'Password',
                          obscureTextNotifier: passwordVisibleNotifier,
                          prefixIconData: Icons.lock,
                          suffixIconData: model.isVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          controller: _initialNewPasswordController,
                          onChanged: (value) {
                            errorNotifier.value =
                                value != _confirmNewPasswordController.text
                                    ? 'Passwords must match'
                                    : null;
                          },
                          onSaved: (value) {
                            changePasswordController.password = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        TextFieldWidget<ChangePasswordModel>(
                          suffixIconClickable: true,
                          // key: Key("_password"),
                          hintText: 'Confirm Password',
                          obscureTextNotifier: confirmPasswordVisibleNotifier,
                          prefixIconData: Icons.lock,
                          suffixIconData: model.isVisible1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          controller: _confirmNewPasswordController,
                          onChanged: (value) {
                            errorNotifier.value =
                                value != _initialNewPasswordController.text
                                    ? 'Passwords must match'
                                    : null;
                          },
                          onSaved: (value) {
                            confirmChangePasswordController.password = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm password cannot be empty';
                            } else if (value !=
                                _initialNewPasswordController.text) {
                              return 'Passwords must match';
                            }
                            return null;
                          },
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: errorNotifier,
                          builder: (context, error, _) => Text(error ?? '',
                              style: const TextStyle(
                                  color: AppColors.colorWarning)),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ButtonWidget(
                          title: 'Reset Password',
                          hasBorder: false,
                          onPressed: () async {
                            print('Reset Password button pressed');
                            var response = await _changePassword(
                                _initialNewPasswordController.text,
                                _confirmNewPasswordController.text);
                            print("Response in UI: $response");
                            if (response!.containsKey('message')) {
                              if (response['message'] ==
                                  'Password updated successfully') {
                                DialogUtils.showWarningDialog(
                                  _scaffoldKey.currentContext!,
                                  "Password updated successfully!",
                                  "Success",
                                  onOkPressed: () {
                                    Navigator.push(
                                      _scaffoldKey.currentContext!,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                    );
                                  },
                                );
                                // Navigator.push(
                                //   _scaffoldKey.currentContext!,
                                //   MaterialPageRoute(
                                //     builder: (context) => const LoginView(),
                                //   ),
                                //);
                              } else if (response['message'] ==
                                  'Error updating password') {
                                DialogUtils.showWarningDialog(
                                    _scaffoldKey.currentContext!,
                                    "Updating password Failed!",
                                    "Warning");
                              } else if (response['message'] ==
                                  'Wrong password') {
                                DialogUtils.showWarningDialog(
                                    _scaffoldKey.currentContext!,
                                    "Wrong password \n Please check password!",
                                    "Warning");
                              } else if (response['message'] ==
                                  'Invalid Email') {
                                DialogUtils.showWarningDialog(
                                    _scaffoldKey.currentContext!,
                                    "Email not found or invalid \n Please check email!",
                                    "Warning");
                              } else {
                                print('Error at login');
                                DialogUtils.showWarningDialog(
                                    _scaffoldKey.currentContext!,
                                    "Updating password Failed!",
                                    "Warning");
                              }
                            } else {
                              print('Error at login');
                            }
                          },
                        ),
                      ]),
                ])))));
  }

  ApiMethod apiMethod = ApiMethod();
  Future<Map<String, dynamic>?> _changePassword(
      String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords must match'); // Handle mismatch error
      }
      EncryptionUtils encryptionUtils = EncryptionUtils();
      var hashedPasswordWithSalt = encryptionUtils
          .encryptPasswordWithArgon2andSalt(password, Uint8List(0));

      final prefsUtils =
          Provider.of<SharedPreferencesUtils>(context, listen: false);
      final email = await prefsUtils.getUserEmailFromSharedPreferences();

      // Send the hashed password and email to the server instead of the plain password
      // ...Implement your API call here using the hashed password and email...
      final res =
          await apiMethod.changePassword(hashedPasswordWithSalt, email!);
      print('Response: $res');
      return res;
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

  Uint8List generateSalt({int length = 32}) {
    var random = Random.secure();
    return Uint8List.fromList(
        List.generate(length, (_) => random.nextInt(256)));
  }
}
