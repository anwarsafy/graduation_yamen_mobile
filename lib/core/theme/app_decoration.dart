import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';

class AppDecoration {
// Background decorations
  static BoxDecoration get backgroundWhite => BoxDecoration(
        color: appTheme.whiteA700,
      );

  static BoxDecoration get backgroundBlack => BoxDecoration(
        color: appTheme.black,
      );

// Black decorations
  static BoxDecoration get black => BoxDecoration(
        color: appTheme.gray90002,
      );

// Color decorations
  static BoxDecoration get colorInputdefault => BoxDecoration(
        color: appTheme.gray100,
      );

// Fill decorations
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red100,
      );

  static BoxDecoration get fillblue => BoxDecoration(
        color: appTheme.gradientShade1.withOpacity(0.85),
      );

// Gradient decorations
  static BoxDecoration get gradientPrimaryToPrimary => BoxDecoration(
        gradient: LinearGradient(
            begin: const Alignment(0.5, 0),
            end: const Alignment(0.5, 1),
            colors: [
              theme.colorScheme.primary.withOpacity(0.45),
              theme.colorScheme.primary,
            ]),
      );

  // Gradient decorations
  static BoxDecoration get gradientTabs => BoxDecoration(
        gradient: LinearGradient(
            begin: const Alignment(0.5, 0),
            end: const Alignment(0.5, 1),
            colors: [
              appTheme.lightBackground,
              // appTheme.lightBackground.withOpacity(0.1),

              appTheme.lightBackground.withOpacity(0.7),

              // appTheme.whiteA700,
            ]),
      );

// Iris decorations
  static BoxDecoration get iris80 => BoxDecoration(
        color: appTheme.indigo30001,
      );

  static BoxDecoration get outlineGray => BoxDecoration(
      color: appTheme.whiteA700,
      border: Border.all(
        color: appTheme.gray700,
        width: 1.h,
      ));

  static BoxDecoration get lightbackground => BoxDecoration(
      color: const Color(0xFFF4F1EA),
      border: Border.all(
        color: appTheme.gray700,
        width: 1.h,
      ));

  static BoxDecoration get outlineGray200 => BoxDecoration(
          border: Border.all(
        color: appTheme.gray200,
        width: 1.h,
      ));

  static BoxDecoration get outlineGray100 => BoxDecoration(
          border: Border.all(
        color: appTheme.gray600.withOpacity(0.5),
        width: 1.h,
      ));

// Strock decorations
  static BoxDecoration get strockGray => BoxDecoration(
        color: appTheme.blueGray5059,
      );

// Text decorations
  static BoxDecoration get textDark100 => BoxDecoration(
        color: appTheme.black900,
      );

// White decorations
  static BoxDecoration get white => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.gray5099,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              16,
            ),
          ),
        ],
      );
}

class BorderRadiusStyle {
// Circle borders
  static BorderRadius get circleBorder12 => BorderRadius.circular(
        12.h,
      );

  static BorderRadius get circleBorder28 => BorderRadius.circular(
        28.h,
      );

  static BorderRadius get circleBorder60 => BorderRadius.circular(
        60.h,
      );

// Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.vertical(
        bottom: Radius.circular(12.h),
      );

  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
        bottom: Radius.circular(20.h),
      );

  static BorderRadius get customBorderTL10 => BorderRadius.only(
        topLeft: Radius.circular(10.h),
        topRight: Radius.circular(10.h),
        bottomRight: Radius.circular(10.h),
      );

  static BorderRadius get customBorderTL101 => BorderRadius.only(
        topLeft: Radius.circular(10.h),
        topRight: Radius.circular(10.h),
        bottomLeft: Radius.circular(10.h),
      );

// Rounded borders
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );

  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h,
      );

  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
}
