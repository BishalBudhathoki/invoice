import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/textField_widget.dart';
import 'package:invoice/app/ui/widgets/wave_animation_widget.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final model = Provider.of<LoginModel>(context);

    return Scaffold(
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
            color: AppColors.colorWhite,),
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
                onChanged: (value) {
                  model.isValidEmail(value);
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFieldWidget(
                hintText: 'Password',
                obscureText: model.isVisible ? false : true,
                prefixIconData: Icons.lock,
                suffixIconData:
                    model.isVisible ? Icons.visibility : Icons.visibility_off,
                onChanged: (value) {
                  model.isValidEmail(value);
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 265.0),
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.colorFontPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ButtonWidget(
                title: 'Login',
                hasBorder: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ButtonWidget(
                title: 'Sign Up',
                hasBorder: true,
                onPressed: () {},
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
}
