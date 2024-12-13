import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/features/auth/models/signup_model.dart';
import 'package:MoreThanInvoice/app/features/auth/viewmodels/signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Consumer<SignupViewModel>(
        builder: (context, signupViewModel, child) {
          return Form(
            key: signupViewModel.formKey,
            child: Column(
              children: [
                TextFieldWidget<SignupModel>(
                  hintText: 'Email',
                  controller: signupViewModel.model.emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  onSaved: (value) {
                    signupViewModel.model.emailController.text = value!;
                  },
                  obscureTextNotifier: ValueNotifier<bool>(false),
                  suffixIconClickable: false,
                ),
                TextFieldWidget<SignupModel>(
                  hintText: 'Password',
                  controller: signupViewModel.model.passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  onSaved: (value) {
                    signupViewModel.model.passwordController.text = value!;
                  },
                  obscureTextNotifier: ValueNotifier<bool>(true),
                  suffixIconClickable: true,
                ),
                TextFieldWidget<SignupModel>(
                  hintText: 'Confirm Password',
                  controller: signupViewModel.model.confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  onSaved: (value) {
                    signupViewModel.model.confirmPasswordController.text = value!;
                  },
                  obscureTextNotifier: ValueNotifier<bool>(true),
                  suffixIconClickable: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    signupViewModel.signup(context);
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}