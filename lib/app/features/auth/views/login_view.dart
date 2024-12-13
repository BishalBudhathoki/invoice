import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/wave_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/features/auth/models/login_model.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      body: Stack(
        //key: loginViewModel.formKey,
        children: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<LoginViewModel>(
                  builder: (context, loginViewModel, child) {
                    return Form(
                      key: loginViewModel.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Ensure this is set
                        children: [
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          TextFieldWidget<LoginModel>(
                            hintText: 'Email',
                            controller: loginViewModel.model.emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              loginViewModel.model.isValidEmail(value);
                            },
                            onSaved: (value) {
                              loginViewModel.model.emailController.text =
                                  value!;
                            },
                            obscureTextNotifier: ValueNotifier<bool>(false),
                            suffixIconClickable: false,
                            suffixIconData: loginViewModel.model.suffixIconData,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          TextFieldWidget<LoginModel>(
                            hintText: 'Password',
                            controller: loginViewModel.model.passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            onSaved: (value) {
                              loginViewModel.model.passwordController.text =
                                  value!;
                            },
                            obscureTextNotifier: ValueNotifier<bool>(
                                loginViewModel.model.isVisible),
                            suffixIconClickable: true,
                            getSuffixIcon: (isVisible) => isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/forgotPassword');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: AppDimens.fontSizeSmall,
                                  color: AppColors.colorFontAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          ButtonWidget(
                            title: 'Login',
                            hasBorder: false,
                            onPressed: () async {
                              if (loginViewModel.formKey.currentState!
                                  .validate()) {
                                var response =
                                    await loginViewModel.login(context);
                                if (response != null &&
                                    response.containsKey('message')) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Warning'),
                                          content: Text(response['message']),
                                          actions: [
                                            TextButton(
                                              child: const Text('OK'),
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
                              Navigator.pushNamed(context, '/signup');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
