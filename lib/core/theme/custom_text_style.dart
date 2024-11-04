import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';


extension on TextStyle {
  // TextStyle get sFUIText {
  //   return copyWith(
  //     fontFamily: 'SF UI Text',
  //   );
  // }

  // TextStyle get euclidCircularA {
  //   return copyWith(
  //     fontFamily: 'Euclid Circular A',
  //   );
  // }

  // TextStyle get roboto {
  //   return copyWith(
  //     fontFamily: 'Roboto',
  //   );
  // }

  // TextStyle get pacifico {
  //   return copyWith(
  //     fontFamily: 'Pacifico',
  //   );
  // }

  // TextStyle get inter {
  //   return copyWith(
  //     fontFamily: 'Inter',
  //   );
  // }

  // TextStyle get sFProText {
  //   return copyWith(
  //     fontFamily: 'SF Pro Text',
  //   );
  // }

  // TextStyle get poppins {
  //   return copyWith(
  //     fontFamily: 'Poppins',
  //   );
  // }

  // TextStyle get assistant {
  //   return copyWith(
  //     fontFamily: 'Assistant',
  //   );
  // }
  TextStyle get lamaSans {
    return copyWith(
      fontFamily: 'LamaSans',
    );
  }
}

class CustomTextStyles {
// Body text style
  static get bodyLargeAssistantOnPrimary =>
      theme.textTheme.bodyLarge!.lamaSans.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 16.sh,
      );

  static get bodyLargeAssistantOnPrimaryRed =>
      theme.textTheme.bodyLarge!.lamaSans.copyWith(
        color: Colors.red,
        fontSize: 16.sh,
      );

  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black,
        fontSize: 16.sh,
      );

  static get bodyLargeRoboto => theme.textTheme.bodyLarge!.lamaSans;

  static get bodyLargeRoboto_1 => theme.textTheme.bodyLarge!.lamaSans;

  static get bodyMediumBluegray700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray700,
      );

  static get bodyMediumGray500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
      );

  static get bodyMediumGray500_1 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
      );

  static get bodyMediumGray90002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray90002,
        fontSize: 15.sh,
      );

  static get bodyMediumLight => theme.textTheme.bodyMedium!.copyWith(
        fontWeight: FontWeight.w300,
      );

  static get bodyMediumPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
      );

  static get bodyMediumPrimary15 => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.sh,
      );

  static get bodyMediumPrimary16 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 15.sh,
      );

  static get bodyMediumRedA200 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.redA200,
        fontSize: 15.sh,
      );

  static get bodyMediumWhiteA700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA700.withOpacity(0.6),
      );

  static get bodySmallInterGray40001 =>
      theme.textTheme.bodySmall!.lamaSans.copyWith(
        color: appTheme.gray40001,
      );

  static get bodySmallPacifico => theme.textTheme.bodySmall!.lamaSans;

  static get bodySmallSFUITextBluegray900 =>
      theme.textTheme.bodySmall!.lamaSans.copyWith(
        color: appTheme.blueGray900,
      );

// Display text style
  static get displayMediumMedium => theme.textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );

// Headline text style
  static get headlineLargePrimary => theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );

  static get headlineLargePrimaryLight =>
      theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w300,
      );

  static get headlineLargeWhiteA700 => theme.textTheme.headlineLarge!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );

  static get headlineSmallRoboto => theme.textTheme.headlineSmall!.lamaSans;

// Label text style
  static get labelLargeBluegray900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray900,
      );

  static get labelLargeInterGray60002 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gray60002,
      );

  static get labelLargePoppinsGray600 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gray600,
      );

  static get labelLargePoppinsGray60002 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gray60002,
      );

  static get labelLargePoppinsGray60013 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gray600,
        fontSize: 13.sh,
      );

  static get labelLargePoppinsGray700 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w600,
      );

  static get labelLargePoppinsIndigoA200 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.indigoA200,
        fontSize: 13.sh,
      );

  static get labelLargePoppinsWhiteA700 =>
      theme.textTheme.labelLarge!.lamaSans.copyWith(
        color: appTheme.gradientShade2,
        fontSize: 13.sh,
      );

  static get labelLargeSFUIText => theme.textTheme.labelLarge!.lamaSans;

// Poppins text style
  static get poppinsYellow400 => TextStyle(
        color: appTheme.yellow400,
        fontSize: 100.sh,
        fontWeight: FontWeight.w600,
      ).lamaSans;

// Title text style
  static get titleLargePrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 20.sh,
        fontWeight: FontWeight.w400,
      );

  static get titleLargeRegular => theme.textTheme.titleLarge!.copyWith(
        fontSize: 20.sh,
        fontWeight: FontWeight.w400,
      );

  static get titleLargeRegular20 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 20.sh,
        fontWeight: FontWeight.w400,
      );

  static get titleMediumAssistantOnPrimary =>
      theme.textTheme.titleMedium!.lamaSans.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 17.sh,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumAssistantPrimary =>
      theme.textTheme.titleMedium!.lamaSans.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 17.sh,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumAssistantWhiteA700 =>
      theme.textTheme.titleMedium!.lamaSans.copyWith(
        color: appTheme.gradientShade1,
        fontSize: 17.sh,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumBlack900SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 18.sh,
        fontWeight: FontWeight.w600,
      );

  static get titleMediumBlack900_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
      );

  static get titleMediumBlack900_2 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
      );

  static get titleMediumEuclidCircularAGray90002 =>
      theme.textTheme.titleMedium!.lamaSans.copyWith(
        color: appTheme.gray90002,
        fontSize: 17.sh,
      );

  static get titleMediumGray90001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumRobotoPrimary =>
      theme.textTheme.titleMedium!.lamaSans.copyWith(
        color: theme.colorScheme.primary,
      );

  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 18.sh,
      );

  static get titleSmallErrorContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallErrorContainerMedium =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontSize: 15.sh,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallGray50001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray50001,
        fontSize: 15.sh,
      );

  static get titleSmallInterBluegray100 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.blueGray100,
      );

  static get titleSmallInterBluegray700 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.blueGray700,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallInterErrorContainer =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: theme.colorScheme.errorContainer,
      );

  static get titleSmallInterGray50001 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.gray50001,
        fontSize: 15.sh,
      );

  static get titleSmallInterGray5000115 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.gray50001,
        fontSize: 15.sh,
      );

  static get titleSmallInterGray5001 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.gray5001,
      );

  static get titleSmallInterGray90001 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.gray90001,
      );

  static get titleSmallInterPrimary =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: theme.colorScheme.primary,
      );

  static get titleSmallInterPrimary15 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.sh,
      );

  static get titleSmallInterPrimaryContainer =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: theme.colorScheme.primaryContainer,
      );

  static get titleSmallInterPrimaryContainer15 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontSize: 15.sh,
      );

  static get titleSmallInterPrimaryContainerRed =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.whiteA700,
        fontSize: 15.sh,
      );

  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );

  static get bottomNavigationBarTextStyle =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.lightSurface,
        fontWeight: FontWeight.w500,
      );

  static get hintSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray500,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallPrimary15 => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.sh,
      );

  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer,
      );

  static get titleSmallPrimaryMedium => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w500,
      );

  static get titleSmallSFProTextBluegray90001 =>
      theme.textTheme.titleSmall!.lamaSans.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 15.sh,
      );

  static get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
      );
}
