import 'package:flutter/material.dart';
import 'package:invoice/app/core/view-models/Base_model.dart';
import 'package:invoice/app/core/view-models/changePassword_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
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
          obscureText: suffixIconClickable ? !model.isVisible : obscureText,
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
                      //obscureTextNotifier.value = !obscureTextNotifier.value;
                      model.isVisible = !model.isVisible;
                      // Check if isVisible1 property exists in the model
                      if (model is ChangePasswordModel) {
                        //obscureTextNotifier.value = !obscureTextNotifier.value;
                        model.isVisible1 = !model.isVisible1;
                      }
                    }
                  : null,
              icon: Icon(
                suffixIconData,
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
