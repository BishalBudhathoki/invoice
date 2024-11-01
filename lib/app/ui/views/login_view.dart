import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MoreThanInvoice/app/core/view-models/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/ui/views/forgot_password_view.dart';
import 'package:MoreThanInvoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/bottom_navBar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/core/controllers/login_controller.dart';
import 'package:MoreThanInvoice/app/core/view-models/login_model.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/ui/views/signup_view.dart';
import 'package:MoreThanInvoice/app/ui/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/showWarningDiaglog_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/textField_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/wave_animation_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginUserNameControllerState();
  }
}

class _LoginUserNameControllerState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Delay the execution using Future.delayed to wait for the context to be available.
    Future.delayed(Duration.zero, () {
      try {
        fetchAndUpdateUserPhoto(
          _userEmailController.text.toLowerCase().trim(),
          Provider.of<PhotoData>(_keyLoader.currentContext!, listen: false),
        );
      } catch (e) {
        print("Null received so no photo uploaded on database");
      }
    });
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchAndUpdateUserPhoto(
      String email, PhotoData photoDataProvider) async {
    print("Fetching and updating user photo for email: $email");
    Uint8List? imageData =
        await apiMethod.getUserPhotoFromFBS(photoDataProvider);
    print("Image data at login: $imageData");
    photoDataProvider.updatePhotoData(imageData);
    print("User photo updated successfully");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<LoginModel>(context);
    final LoginController loginController = LoginController();
    final passwordVisibleNotifier = ValueNotifier<bool>(true);
    final textVisibleNotifier = ValueNotifier<bool>(false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.colorWhite,
      body: Stack(children: <Widget>[
        Container(
          height: 400,
          color: AppColors.colorPrimary,
        ),
        const SizedBox(
          height: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          duration: const Duration(milliseconds: 500),
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
              TextFieldWidget<LoginModel>(
                suffixIconClickable: false,
                hintText: 'Email',
                obscureTextNotifier: textVisibleNotifier,
                prefixIconData: Icons.mail_outline,
                suffixIconData: model.isValid ? Icons.check : null,
                controller: _userEmailController,
                onChanged: (value) {
                  model.isValidEmail(value);
                },
                onSaved: (value) {
                  loginController.email = value!;
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
              TextFieldWidget<LoginModel>(
                suffixIconClickable: true,
                // key: Key("_password"),
                hintText: 'Password',
                obscureTextNotifier: passwordVisibleNotifier,
                prefixIconData: Icons.lock,
                suffixIconData:
                    model.isVisible ? Icons.visibility : Icons.visibility_off,
                controller: _passwordController,
                onChanged: (value) {
                  //model.isValidEmail(value);
                },
                onSaved: (value) {
                  loginController.password = value!;
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordView()),
                  );
                },
                child: const FittedBox(
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
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ButtonWidget(
                title: 'Login',
                hasBorder: false,
                onPressed: () async {
                  if (_userEmailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Warning',
                              style: Theme.of(context).textTheme.bodyLarge),
                          content: Text('Email or password field is empty.',
                              style: Theme.of(context).textTheme.bodyMedium),
                          actions: [
                            TextButton(
                              child: Text('OK',
                                  style: Theme.of(context).textTheme.bodyLarge),
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
                  showAlertDialog(context);

                  if (kDebugMode) {
                    print('Login button pressed');
                  }

                  Timer timer = Timer(const Duration(seconds: 40), () {
                    // Display warning after 3 seconds (adjust the duration as needed)
                    Navigator.of(context).pop(); // Close the dialog

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Warning',
                              style: Theme.of(context).textTheme.bodyLarge),
                          content: Text(
                              'Login process is taking longer than expected.',
                              style: Theme.of(context).textTheme.bodyMedium),
                          actions: [
                            TextButton(
                              child: Text('OK',
                                  style: Theme.of(context).textTheme.bodyLarge),
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

                  var response = await _handleSubmitted();
                  timer.cancel(); // Cancel the timer

                  if (response!.containsKey('message')) {
                    if (response['message'] == 'user found') {
                      print("Before fetchAndUpdateUserPhoto");
                      await fetchAndUpdateUserPhoto(
                          _userEmailController.text.toLowerCase().trim(),
                          Provider.of<PhotoData>(context, listen: false));
                      print("After fetchAndUpdateUserPhoto");
                      Navigator.pop(_scaffoldKey.currentContext!);
                      Navigator.push(
                        _scaffoldKey.currentContext!,
                        MaterialPageRoute(
                          builder: (context) => BottomNavBarWidget(
                            email:
                                _userEmailController.text.toLowerCase().trim(),
                            role: response['role'],
                          ),
                        ),
                      );
                    } else if (response['message'] == 'User not found') {
                      DialogUtils.showWarningDialog(
                          _scaffoldKey.currentContext!,
                          "User not found \n Please Sign up!",
                          "Warning");
                    } else if (response['message'] == 'Wrong password') {
                      DialogUtils.showWarningDialog(
                          _scaffoldKey.currentContext!,
                          "Wrong password \n Please check password!",
                          "Warning");
                    } else if (response['message'] == 'Invalid Email') {
                      DialogUtils.showWarningDialog(
                          _scaffoldKey.currentContext!,
                          "Email not found or invalid \n Please check email!",
                          "Warning");
                    } else {
                      print('Error at login');
                      DialogUtils.showWarningDialog(
                          _scaffoldKey.currentContext!,
                          "Error at login!",
                          "Warning");
                      Navigator.of(_scaffoldKey.currentContext!,
                              rootNavigator: true)
                          .pop();
                    }
                  } else {
                    print('Error at login');
                    Navigator.pop(_scaffoldKey.currentContext!);
                    Navigator.of(_scaffoldKey.currentContext!,
                            rootNavigator: true)
                        .pop();
                  }
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ButtonWidget(
                title: 'Sign Up',
                hasBorder: true,
                onPressed: () {
                  print('Sign Up button pressed');
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

  ApiMethod apiMethod = ApiMethod();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> _handleSubmitted() async {
    print("Username: ${_userEmailController.text.toLowerCase().trim()}");
    print("Password: ${_passwordController.text.trim()}");

    try {
      // final UserCredential userCredential =
      //     await _auth.signInWithEmailAndPassword(
      //   email: _userEmailController.text.toLowerCase().trim(),
      //   password: _passwordController.text.trim(),
      // );
      //
      // print("User: ${userCredential.user}");
      // if (userCredential.user != null) {
      //   // User found, continue with your logic
      //   if (kDebugMode) {
      //     print('User from firebase: ${userCredential.user!.email}');
      //   }
      return await apiMethod.login(
        _userEmailController.text.toLowerCase().trim(),
        _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors here
      Navigator.of(context, rootNavigator: true).pop();
      print('Firebase Authentication Error: ${e.code}');
      switch (e.code) {
        case 'invalid-email':
          return {
            'message': 'Invalid Email', // Return the message here
          };
        case 'wrong-password':
          return {
            'message': 'Wrong password', // Return the message here
          };
        case 'user-not-found':
          //showWarningDialog(e.code);
          return {
            'message': 'User not found', // Return the message here
          };
        case 'user-disabled':
          return {
            'message': 'User disabled', // Return the message here
          };
      }
    } catch (e) {
      // Handle other exceptions here
      print('Error at login or authentication: $e');
    }

    // If execution reaches here, handle any other cases or return null as needed
    return null;
  }
}
