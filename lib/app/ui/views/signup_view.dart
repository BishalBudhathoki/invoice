import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/classes/signupResult.dart';
import 'package:invoice/app/core/controllers/signup_controller.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/bottom_navBar_widget.dart';
import 'package:invoice/app/core/view-models/signup_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/flushbar_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:invoice/backend/encryption_utils.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  @override
  _SignupUserNameControllerState createState() {
    return _SignupUserNameControllerState();
  }
}

class _SignupUserNameControllerState extends State<SignUpView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _signUpUserFirstNameController = TextEditingController();
  final _signUpUserLastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();
  final _signupABNController = TextEditingController();

  var ins;
  dynamic result;

  @override
  void dispose() {
    _signUpUserFirstNameController.dispose();
    _signUpUserLastNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final models = Provider.of<SignupModel>(context);
    bool loading = false;
    FlushBarWidget flushBarWidget = FlushBarWidget();
    final passwordVisibleNotifier = ValueNotifier<bool>(true);
    final textVisibleNotifier = ValueNotifier<bool>(false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: context.height * 0.023),
                const Text(
                  'SignUp',
                  style: TextStyle(
                    color: AppColors.colorFontAccent,
                    fontSize: AppDimens.fontSizeXXMax,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: context.height * 0.023),
                const Text(
                  'Create an account, It\'s free',
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeNormal,
                    color: AppColors.colorFontPrimary,
                  ),
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: false,
                  hintText: 'First Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  obscureTextNotifier: textVisibleNotifier,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserFirstNameController,
                  onChanged: (value) {},
                  onSaved: (value) {
                    //signup_controller.signup_user_first_name = value;
                  },
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: false,
                  hintText: 'Last Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  obscureTextNotifier: textVisibleNotifier,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserLastNameController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: false,
                  hintText: 'ABN',
                  validator: (value) {
                    if (value!.isEmpty || value.length < 11) {
                      return 'Please enter correct ABN or check length of ABN';
                    }
                    return null;
                  },
                  obscureTextNotifier: textVisibleNotifier,
                  prefixIconData: Icons.account_balance,
                  suffixIconData: null,
                  controller: _signupABNController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: false,
                  hintText: 'Email',
                  obscureTextNotifier: textVisibleNotifier,
                  prefixIconData: Icons.mail_outline,
                  suffixIconData: models.isValid ? Icons.check : null,
                  controller: _signUpEmailController,
                  onChanged: (value) {
                    models.isValidEmail(value);
                  },
                  onSaved: (value) {
                    _signUpEmailController.text = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: true,
                  hintText: 'Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  obscureTextNotifier: passwordVisibleNotifier,
                  prefixIconData: Icons.lock,
                  suffixIconData: null,
                  controller: _signUpPasswordController,
                  onChanged: (value) {
                    //model.isValidEmail(value);
                  },
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget<SignupModel>(
                  suffixIconClickable: true,
                  hintText: 'Confirm Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter correct password';
                    }
                    return null;
                  },
                  obscureTextNotifier: passwordVisibleNotifier,
                  prefixIconData: Icons.lock,
                  suffixIconData: models.isValid ? Icons.check : null,
                  controller: _signUpConfirmPasswordController,
                  onChanged: (value) {
                    models.isValidPassword(
                        value, _signUpPasswordController.text);
                  },
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                ButtonWidget(
                  title: 'Sign Up',
                  hasBorder: false,
                  onPressed: () async {
                    if (models.isValid) {
                      showAlertDialog(context);
                      Future.delayed(const Duration(seconds: 3), () async {
                        final response = await _signupUser();
                        //debugPrint('Sign up Response: ${response.toString()}');
                        if (response.success) {
                          // Handle success
                          flushBarWidget
                              .flushBar(
                                title: response.title,
                                message: response.message,
                                backgroundColor: AppColors.colorSecondary,
                                context: _scaffoldKey.currentContext!,
                              )
                              .show(_scaffoldKey.currentContext!);

                          // Additional success handling if needed
                          print('Signup button pressed');
                          Future.delayed(const Duration(seconds: 3), () async {
                            Navigator.push(
                              _scaffoldKey.currentContext!,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBarWidget(
                                  email: _signUpEmailController.text
                                      .toLowerCase()
                                      .trim(),
                                  role: 'normal',
                                ),
                              ),
                            );
                          });
                        } else {
                          // Handle error
                          flushBarWidget
                              .flushBar(
                                title: response.title,
                                message: response.message,
                                backgroundColor: response.backgroundColor,
                                context: _scaffoldKey.currentContext!,
                              )
                              .show(_scaffoldKey.currentContext!);
                        }
                      });
                    }

                    //login_controller.login(_userNameController.text, _passwordController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ApiMethod apiMethod = ApiMethod();

  Future<SignupResult> _signupUser() async {
    SignupController signupController = SignupController();
    if (_signUpPasswordController.text ==
        _signUpConfirmPasswordController.text) {
      bool success = await signupController.signupUser(
        _signUpUserFirstNameController.text,
        _signUpUserLastNameController.text,
        _signUpEmailController.text,
        _signUpPasswordController.text,
        _signupABNController.text,
        "normal",
      );
      print("Success: $success");
      if (success == true) {
        final checkEmailResponse = await apiMethod
            .checkEmail(_signUpEmailController.text.trim().toLowerCase());
        print("Check Email Response: $checkEmailResponse");
        if (checkEmailResponse?['message'] == "Email not found") {
          result = await apiMethod.signupUser(
            _signUpUserFirstNameController.text,
            _signUpUserLastNameController.text,
            _signUpEmailController.text,
            _signUpPasswordController.text,
            _signupABNController.text,
            "normal",
          );
          print("Res: $result");
          await _changePassword(
            _signUpPasswordController.text,
            _signUpConfirmPasswordController.text,
          ).then((response) async {
            if (response is Map && response!.containsKey('message')) {
              if (response['message'] == 200) {
                print('Password changed successfully');
              }
            }
          });
          String message = "";

          // Check for success or error based on the server response
          if (result is Map) {
            //int statusCode = result["statusCode"];
            message = result["message"] ?? "Unknown error";

            if (result["message"] == "Signup successful") {
              print("1");
              return SignupResult(
                success: true,
                title: "Success",
                message: message,
                backgroundColor: AppColors.colorPrimary,
              );
            } else {
              print("2");
              return SignupResult(
                success: false,
                title: "Error",
                message: message,
                backgroundColor: AppColors.colorWarning,
              );
            }
          } else {
            print("3");
            return SignupResult(
              success: false,
              title: "Error",
              message: "Unknown error",
              backgroundColor: AppColors.colorWarning,
            );
          }
        }
      } else {
        print("4");
        return SignupResult(
          success: false,
          title: "Error",
          message: "The email address is already in use by another account",
          backgroundColor: AppColors.colorWarning,
        );
      }
    } else {
      print("5");
      return SignupResult(
        success: false,
        title: "Error",
        message: "Passwords do not match",
        backgroundColor: AppColors.colorWarning,
      );
    }
    print("6");
    return SignupResult(
      success: false,
      title: "Error",
      message: "Email exist in database",
      backgroundColor: AppColors.colorWarning,
    );
  }

  Future<Map<String, dynamic>?> _changePassword(
      String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords must match'); // Handle mismatch error
      }
      EncryptionUtils encryptionUtils = EncryptionUtils();
      var hashedPasswordWithSalt = encryptionUtils
          .encryptPasswordWithArgon2andSalt(password, Uint8List(0));

      final email = _signUpEmailController.text.toLowerCase().trim();

      // Send the hashed password and email to the server instead of the plain password
      // ...Implement your API call here using the hashed password and email...
      final res = await apiMethod.changePassword(hashedPasswordWithSalt, email);
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
