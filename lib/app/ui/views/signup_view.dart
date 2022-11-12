import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/controllers/signup_controller.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoice/app/core/view-models/signup_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});
  @override
  _SignupUserNameControllerState createState() {
    return _SignupUserNameControllerState();
  }
}

class _SignupUserNameControllerState extends State<SignUpView> {
  final _signUpUserFirstNameController = TextEditingController();
  final _signUpUserLastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

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
                    color: AppColors.colorFontSecondary,
                  ),
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'First Name',
                  obscureText: false,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserFirstNameController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Last Name',
                  obscureText: false,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserLastNameController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Email',
                  obscureText: false,
                  prefixIconData: Icons.email,
                  suffixIconData: null,
                  controller: _signUpEmailController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Password',
                  obscureText: true,
                  prefixIconData: Icons.lock,
                  suffixIconData: null,
                  controller: _signUpPasswordController,
                  onChanged: (value) {
                    //model.isValidEmail(value);
                  },
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Confirm Password',
                  obscureText: true,
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
                    if(models.isValid) {
                      showAlertDialog(context);
                      Future.delayed(const Duration(seconds: 3), () async {
                        final response = await _signupUser(_signUpEmailController.text);
                        if (response) {
                          print('Signup button pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                HomeView(
                                  email: _signUpEmailController.text,
                                  // lastName: _signUpUserLastNameController.text,
                                )),
                          );
                        } else {
                          print('Error at signup');
                          Navigator.of(context, rootNavigator: true).pop();
                        }

                        //_login();
                      });

                    }

                    //login_controller.login(_userNameController.text, _passwordController.text);
                  },
                ),
                SizedBox(height: context.height * 0.023),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeNormal,
                        color: AppColors.colorFontSecondary,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeNormal,
                        color: AppColors.colorPrimary,
                      ),
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

  ApiMethod apiMethod = new ApiMethod();
  Future<bool> _signupUser(String email) async {
    var ins = await apiMethod.signupUser(
        _signUpUserFirstNameController.text,
        _signUpUserLastNameController.text,
        _signUpEmailController.text,
        _signUpPasswordController.text,
    );
    //print("Response: "+ ins['email'].toString() );

    if (_signUpPasswordController.text == _signUpConfirmPasswordController.text) {
      // if(ins['email'] != null) {
      //
      // }
      if (kDebugMode) {
        // _apiResponse.Data = LoginModel.fromJson(json.decode(response.body));
        print("Login Successful ");
      }

      return true;
    } else {
      if (kDebugMode) {
        print("Login Failed");
      }
      return false;
    }
  }
}
