import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:pinput/pinput.dart';

class VerifyOTPView extends StatefulWidget {
  const VerifyOTPView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _VerifyOTPState();
  }
}

class _VerifyOTPState extends State<VerifyOTPView> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    TextEditingController textEditingController = TextEditingController();

    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(AppDimens.padding),
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  SizedBox(height: context.height * 0.023),
                  const Text(
                    'Verify OTP!',
                    style: TextStyle(
                      color: AppColors.colorFontAccent,
                      fontSize: AppDimens.fontSizeXXMax,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: context.height * 0.023),
                  const Text(
                    'Is this really you?',
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
                        const Pinput(
                          length: 6,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate the entered OTP, you can compare it with the expected OTP
                            print("Entered OTP: ${textEditingController.text}");
                          },
                          child: const Text("Verify"),
                        ),
                      ]),
                ])))));
  }
}
