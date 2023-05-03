import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:invoice/app/ui/views/adminDashBoard.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice/app/core/controllers/login_controller.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/views/signup_view.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/app/ui/widgets/wave_animation_widget.dart';
import 'package:invoice/backend/apiError.dart';
import 'package:invoice/backend/apiResponse.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginUserNameControllerState createState() {
    return _LoginUserNameControllerState();
  }
}

class _LoginUserNameControllerState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<LoginModel>(context);
    final LoginController login_controller = new LoginController();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorWhite,
      body: Stack(children: <Widget>[
        Container(
          height: 400,
          color: AppColors.colorPrimary,
        ),
        Container(
          height: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Login',
                style: TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: AppDimens.fontSizeXXMax,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutQuad,
          top: keyboardOpen ? -size.height / 3.7 : 0.0,
          child: WaveAnimation(
            size: size,
            yOffset: size.height / 3.0,
            color: AppColors.colorWhite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              TextFieldWidget(
                hintText: 'Email',
                obscureText: false,
                prefixIconData: Icons.mail_outline,
                suffixIconData: model.isValid ? Icons.check : null,
                controller: _userEmailController,
                onChanged: (value) {
                  model.isValidEmail(value);
                },
                onSaved: (value) {
                  login_controller.email = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextFieldWidget(
                // key: Key("_password"),
                hintText: 'Password',
                obscureText: model.isVisible ? false : true,
                prefixIconData: Icons.lock,
                suffixIconData:
                    model.isVisible ? Icons.visibility : Icons.visibility_off,
                controller: _passwordController,
                onChanged: (value) {
                  //model.isValidEmail(value);
                },
                onSaved: (value) {
                  login_controller.password = value!;
                },
                validator: (value) {
                  // this is the new line
                  if (value!.isEmpty) {
                    return 'Password is Required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.only(left: 265.0),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
                  ),
                ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ButtonWidget(
                title: 'Login',
                hasBorder: false,
                onPressed: () async {
                  showAlertDialog(context);
                  print('Login button pressed');
                  var currentContext = context; // capture the current context
                  Future.delayed(const Duration(seconds: 3), () async {
                    var response = await _handleSubmitted();

                    if (response['message'] == 'user found') {
                      Navigator.push(
                        _scaffoldKey.currentContext!,
                        MaterialPageRoute(
                          builder: (currentContext) =>
                              // HomeView(
                              //   email: _userEmailController.text.trim(),
                              // ),
                               AdminDashboardView(
                                 email:_userEmailController.text.trim(),
                              ),
                        ),
                      );
                    } else {
                      print('Error at login');
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                    }
                    //_login();
                  });

                  //clearText();

                  //login_controller.login(_userNameController.text, _passwordController.text);
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ButtonWidget(
                title: 'Sign Up',
                hasBorder: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void clearText() {
    _userEmailController.clear();
    _passwordController.clear();
  }

  ApiMethod apiMethod = new ApiMethod();
  //LoginModel model = LoginModel();
  Future<dynamic> _handleSubmitted() async {
    print("Username:  ${_userEmailController.text.trim()}");
    print("Password:  ${_passwordController.text.trim()}");
    var ins = await apiMethod.login(
        _userEmailController.text.trim(), _passwordController.text.trim());
    //print("Response: "+ ins['email'].toString() + ins['password'].toString());
    return ins;
  }
}
