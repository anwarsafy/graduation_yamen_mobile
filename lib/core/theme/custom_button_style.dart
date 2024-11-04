import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
// Filled button style
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray90002,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              10.h,
            ),
            topRight: Radius.circular(
              10.h,
            ),
            bottomLeft: Radius.circular(
              10.h,
            ),
          ),
        ),
      );

  static ButtonStyle get fillPrimaryTL12 => ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.h),
      ));

// Outline button style
  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
      backgroundColor: appTheme.whiteA700,
      side: BorderSide(
        color: appTheme.gray700,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.h),
      ));

  static ButtonStyle get outlineGrayC => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        shadowColor: appTheme.gray9000c,
        elevation: 16,
      );
  static ButtonStyle get outlineYellow => OutlinedButton.styleFrom(
        // backgroundColor: appTheme.yellow,
        // overlayColor: appTheme.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        side: BorderSide(
            color: appTheme.yellow, width: 2.0), // Adjust width as needed
        // shadowColor: appTheme.yellow,
        elevation: 16,
      );

  static ButtonStyle get outlinePrimary => OutlinedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      side: BorderSide(
        color: theme.colorScheme.primary.withOpacity(0.2),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.h),
      ));

// text button style
  static ButtonStyle get none => ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(appTheme.black),
      elevation: WidgetStateProperty.all<double>(0));
}
