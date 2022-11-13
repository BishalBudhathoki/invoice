import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  //final Key key;
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  late final bool obscureText;
  final Function(String) onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  TextFieldWidget({
    //required this.key,
    required this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    required this.obscureText,
    required this.onChanged,
    required this.onSaved,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      //key: key,
      onSaved: onSaved,
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: AppColors.colorPrimary,
      style: const TextStyle(
        color: AppColors.colorPrimary,
        fontSize: AppDimens.fontSizeNormal,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: AppColors.colorPrimary,),
        focusColor: AppColors.colorPrimary,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.colorPrimary,),
        ),
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: AppColors.colorPrimary,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: AppColors.colorPrimary,
          ),
        ),
      ),
    );
  }
}