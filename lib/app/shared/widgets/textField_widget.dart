import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/core/base/base_model.dart';
import 'package:MoreThanInvoice/app/features/auth/models/changePassword_model.dart';
import 'package:provider/provider.dart';

class TextFieldWidget<T extends VisibilityToggleModel> extends StatelessWidget {
  //final Key key;
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  //final bool obscureText;
  final Function(String) onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ValueNotifier<bool> obscureTextNotifier;
  final bool suffixIconClickable;
  TextEditingController? confirmPasswordController;
  final IconData Function(bool isVisible)? getSuffixIcon;
  final bool? confirmPasswordToggle;

  TextFieldWidget({
    super.key,
    //required this.key,
    required this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    //required this.obscureText,
    required this.onChanged,
    required this.onSaved,
    required this.controller,
    required this.validator,
    required this.obscureTextNotifier,
    required this.suffixIconClickable,
    this.confirmPasswordController,
    this.getSuffixIcon,
    this.confirmPasswordToggle,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<T>(context);
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextNotifier,
      builder: (context, obscureText, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          onSaved: onSaved,
          onChanged: onChanged,
          obscureText: suffixIconClickable
              ? (confirmPasswordToggle == true ? !model.isVisible1 : !model.isVisible)
              : obscureText,
          cursorColor: AppColors.colorPrimary,
          style: const TextStyle(
            color: AppColors.colorPrimary,
            fontSize: AppDimens.fontSizeNormal,
          ),
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: AppColors.colorPrimary,
            ),
            focusColor: AppColors.colorPrimary,
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.colorPrimary,
              ),
            ),
            labelText: hintText,
            prefixIcon: Icon(
              prefixIconData,
              size: 18,
              color: AppColors.colorPrimary,
            ),
            suffixIcon: IconButton(
              onPressed: suffixIconClickable
                  ? () {
                debugPrint("${model.isVisible} ${model.isVisible1}");
                if (model is ChangePasswordModel) {
                  debugPrint("Inside ChangePasswordModel $confirmPasswordToggle");
                  if (confirmPasswordToggle == true) {
                    model.isVisible1 = !model.isVisible1; // Toggle confirm password visibility
                  } else {
                    model.isVisible = !model.isVisible; // Toggle new password visibility
                  }
                } else {
                  model.isVisible = !model.isVisible; // Default toggle
                }
              }
                  : null,
              icon: Icon(
                suffixIconData ?? (getSuffixIcon != null ? getSuffixIcon!(confirmPasswordToggle == true ? model.isVisible1 : model.isVisible) : null),
                size: 18,
                color: AppColors.colorPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
