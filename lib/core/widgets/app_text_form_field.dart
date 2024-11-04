import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';


class AppTextFormField extends StatelessWidget {
  final String hint;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool? isObscureText;
  final bool? isDense;
  final TextEditingController? controller;
  final Function(String?) validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField({
    super.key,
    required this.hint,
    this.suffixIcon,
    this.isObscureText,
    this.isDense,
    this.controller,
    this.onChanged,
    this.focusNode,
    required this.validator,
    required this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged,
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.font14Hint500Weight,
        isDense: isDense ?? true,
        filled: true,
        fillColor: ColorsManager.textFieldFillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.gray93Color,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.mainBlue,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.coralRed,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.coralRed,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        suffixIcon: suffixIcon,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyles.font14DarkBlue500Weight,
    );
  }
}