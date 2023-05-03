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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _signUpUserFirstNameController = TextEditingController();
  final _signUpUserLastNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();
  final _signupABNController = TextEditingController();

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
    final SignupController signup_controller = new SignupController();

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
                TextFieldWidget(
                  hintText: 'First Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  obscureText: false,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserFirstNameController,
                  onChanged: (value) {},
                  onSaved: (value) {
                    //signup_controller.signup_user_first_name = value;
                  },
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Last Name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  obscureText: false,
                  prefixIconData: Icons.person,
                  suffixIconData: null,
                  controller: _signUpUserLastNameController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'ABN',
                  validator: (value) {
                    if (value!.isEmpty || value.length < 11) {
                      return 'Please enter correct ABN or check length of ABN';
                    }
                    return null;
                  },
                  obscureText: false,
                  prefixIconData: Icons.account_balance,
                  suffixIconData: null,
                  controller: _signupABNController,
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Email',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter correct email';
                    }
                    return null;
                  },
                  obscureText: false,
                  prefixIconData: Icons.email,
                  suffixIconData: null,
                  controller: _signUpEmailController,
                  onChanged: (value) {
                    models.isValidEmail(value);
                  },
                  onSaved: (value) {},
                ),
                SizedBox(height: context.height * 0.023),
                TextFieldWidget(
                  hintText: 'Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter correct password';
                    }
                    return null;
                  },
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
                    if (models.isValid) {
                      showAlertDialog(context);
                      Future.delayed(const Duration(seconds: 3), () async {
                        final response = await _signupUser();
                        if (response) {
                          print('Signup button pressed');
                          Navigator.push(
                            _scaffoldKey.currentContext!,
                            MaterialPageRoute(
                                builder: (context) => HomeView(
                                      email: _signUpEmailController.text,
                                      // lastName: _signUpUserLastNameController.text,
                                    )),
                          );
                        } else {
                          print('Error at signup');
                          Navigator.of(_scaffoldKey.currentContext!,
                                  rootNavigator: true)
                              .pop();
                        }

                        //_login();
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
  Future<bool> _signupUser() async {
    var ins = await apiMethod.signupUser(
      _signUpUserFirstNameController.text,
      _signUpUserLastNameController.text,
      _signUpEmailController.text,
      _signUpPasswordController.text,
      _signupABNController.text,
    );
    //print("Response: "+ ins['email'].toString() );

    if (_signUpPasswordController.text ==
        _signUpConfirmPasswordController.text) {
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
