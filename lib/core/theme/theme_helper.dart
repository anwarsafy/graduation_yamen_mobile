import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pref_utils.dart';

LightCodeColors get appTheme =>
    ThemeHelper().themeColor(PrefUtils().getThemeData());

ThemeData get theme => ThemeHelper().themeData(PrefUtils().getThemeData());

/// Helper class for managing
// themes and colors.3

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightMode': LightCodeColors(),
    'darkMode': DarkCodeColors(),
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightMode': ColorSchemes.lightCodeColorScheme,
    'darkMode': ColorSchemes.darkCodeColorScheme,
  };

  LightCodeColors _getThemeColors(String themeType) {
    return _supportedCustomColor[themeType] ?? LightCodeColors();
  }

  ThemeData _getThemeData(String themeType) {
    var colorScheme =
        _supportedColorScheme[themeType] ?? ColorSchemes.lightCodeColorScheme;

    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: appTheme.gradientShade2,
        selectionColor: appTheme.gradientShade2,
        cursorColor: appTheme.gradientShade2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: _getThemeColors(themeType).indigoA400,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: _getThemeColors(themeType).gray100,
      ),
    );
  }

  LightCodeColors themeColor(String themeType) => _getThemeColors(themeType);

  ThemeData themeData(String themeType) => _getThemeData(themeType);
}

class DarkCodeColors extends LightCodeColors {
  @override
  Color get bottomNavigationBar => const Color(0xFF000000);

  @override
  Color get gradientShade1 => const Color(0xFFF4F1EA);

  @override
  Color get gradientShade2 => const Color(0xFF9BC7DC);

  @override
  Color get gradientShade3 => const Color(0xFFBBF7FC);

  @override
  Color get gradientShade4 => const Color(0xFF9ACDE4);

  @override
  Color get gradientShade5 => const Color(0xFFBFDBEB);

  @override
  Color get cardColor => const Color(0xFFE6EBF2);

// Black
  @override
  Color get black1000 => const Color(0xFF000000);

  @override
  Color get black900 => const Color(0xFF04021D);

  @override
  Color get white => const Color(0xFFffffff);

  @override
  Color get black => const Color(0xFF000000);

  @override
  Color get backGroundlight => const Color(0xFF1a1c1e);

  @override
  Color get appBarProjectManagement => const Color(0xff2a2f33);

  @override
  Color get bodyProjectManagament => const Color(0xff161a1d);

  @override
  Color get lightPrimary => const Color(0xFF94C3DD);

  @override
  Color get lightSecondary => const Color(0xFF7FAAD2);

  @override
  Color get lightAccent => const Color(0xFF00A9AC);

  @override
  Color get lightBackground => const Color(0xFFF4F1EA);

  @override
  Color get lightBackgroundTwo => const Color(0xFF04021D);

  @override
  Color get lightSurface => const Color(0xFFF6F5F1);

  @override
  Color get lightTextPrimary => const Color(0xFF23245D);

  @override
  Color get lightTextSecondary => const Color(0xFF1C114D);

// BlueGray
  @override
  Color get blueGray100 => const Color(0xFFD1D3D4);

  @override
  Color get blueGray10001 => const Color(0xFFD0D0D0);

  @override
  Color get blueGray400 => const Color(0xFF7F8B9E);

  @override
  Color get blueGray40001 => const Color(0xFF888888);

  @override
  Color get blueGray5059 => const Color(0x59EBECEF);

  @override
  Color get blueGray700 => const Color(0xFF535662);

  @override
  Color get backgroundGray => const Color(0xFF424242);

  @override
  Color get blueGray900 => const Color(0xFF1E1F4B);

  @override
  Color get blueGray90001 => const Color(0xFF29303C);

// DeepPurple
  @override
  Color get deepPurple100 => const Color(0xFFCCC9FB);

// Gray..
  @override
  Color get gray100 => const Color(0xFFF5F5F5);

  @override
  Color get gray200 => const Color(0xFFEFEFEF);

  @override
  Color get gray400 => const Color(0xFFC4C4C4);

  @override
  Color get gray40001 => const Color(0xFFB9B9B9);

  @override
  Color get gray50 => const Color(0xFFFDFBF9);

  @override
  Color get gray500 => const Color(0xFF949BA5);

  @override
  Color get gray50001 => const Color(0xFF9A9FA5);

  @override
  Color get gray5001 => const Color(0xFFFBFBFB);

  @override
  Color get gray5099 => const Color(0x99F5F8FC);

  @override
  Color get gray600 => const Color(0xFF686777);

  @override
  Color get gray60001 => const Color(0xFF696F79);

  @override
  Color get gray60002 => const Color(0xFF6F767D);

  @override
  Color get gray700 => const Color(0xFF636363);

  @override
  Color get gray900 => const Color(0xFF202020);

  @override
  Color get gray90001 => const Color(0xFF1A1D1F);

  @override
  Color get gray90002 => const Color(0xFF202226);

  @override
  Color get gray => Colors.grey;

//transparent
  @override
  Color get transparent => Colors.transparent;

// Grayc
  @override
  Color get gray9000c => const Color(0x0C212226);

// Indigo
  @override
  Color get indigo300 => const Color(0xFF706FE5);

  @override
  Color get indigo30001 => const Color(0xFF7879F1);

  @override
  Color get indigoA200 => const Color(0xFF5D5FEF);

  @override
  Color get indigoA400 => const Color(0xFF554AF0);

// LightGreen
  @override
  Color get lightGreen300 => const Color(0xFF99FF82);

// Lime
  @override
  Color get lime200 => const Color(0xFFE5FFA3);

  @override
  Color get limeA200 => const Color(0xFFD8F542);

// Red
  @override
  Color get red100 => const Color(0xFFFFD5DB);

  @override
  Color get red500 => const Color(0xFFEA4335);

  @override
  Color get redA200 => const Color(0xFFFF5959);

// White
  @override
  Color get whiteA700 => const Color(0xFFFFFFFF);

//
  @override
  Color get blueLightModeToBlack => const Color(0xFF000000);

  @override
  Color get blueLightModeToWhite => const Color(0xFFFFFFFF);

  @override
  Color get whiteLightModeToBlock => const Color(0xFF000000);

  @override
  Color get gradientShade4LightModeToBlock => const Color(0xFF000000);

// Yellow
  @override
  Color get yellow400 => const Color(0xFFFFED54);

  @override
  Color get yellow => const Color(0xFFFFAF00);
}

class LightCodeColors {
  Color get bottomNavigationBar => const Color(0xFF100841);

  Color get gradientShade1 => const Color(0xFF100841);

  Color get gradientShade2 => const Color(0xFF9BC7DC);

  Color get gradientShade3 => const Color(0xFFBBF7FC);

  Color get gradientShade4 => const Color(0xFF9ACDE4);

  Color get gradientShade5 => const Color(0xFFBFDBEB);

  Color get cardColor => const Color(0xFFE6EBF2);

  // Black

  Color get black1000 => const Color(0xFF000000);

  Color get black900 => const Color(0xFF04021D);

  Color get white => const Color(0xFFffffff);

  Color get black => const Color(0xFFffffff);

  Color get backGroundlight => const Color(0xFFf5f5f5);

  Color get appBarProjectManagement => const Color(0xff0043c1);
  Color get bodyProjectManagament => const Color(0xfff1f2f4);

  Color get lightPrimary => const Color(0xFF94C3DD);

  Color get lightSecondary => const Color(0xFF7FAAD2);

  Color get lightAccent => const Color(0xFF00A9AC);

  Color get lightBackground => const Color(0xFF1C114D);

  // Color get lightBG => const Color(0xFFffffff);

  Color get lightBackgroundTwo => const Color(0xFFF4F1EA);

  Color get lightSurface => const Color(0xFF686777);

  Color get lightTextPrimary => const Color(0xFF23245D);

  Color get lightTextSecondary => const Color(0xFF1C114D);

// BlueGray

  Color get blueGray100 => const Color(0xFFD1D3D4);

  Color get blueGray10001 => const Color(0xFFD0D0D0);

  Color get blueGray400 => const Color(0xFF7F8B9E);

  Color get blueGray40001 => const Color(0xFF888888);

  Color get blueGray5059 => const Color(0x59EBECEF);

  Color get blueGray700 => const Color(0xFF535662);

  Color get backgroundGray => const Color(0xFFffffff);

  Color get blueGray900 => const Color(0xFF1E1F4B);

  Color get blue => const Color(0xff2688EB);

  Color get blueGray90001 => const Color(0xFF29303C);

// DeepPurple

  Color get deepPurple100 => const Color(0xFFCCC9FB);

// Grayc

  Color get gray9000c => const Color(0x0C212226);

  // Gray..
  Color get gray100 => const Color(0xFFF5F5F5);

  Color get gray200 => const Color(0xFFEFEFEF);

  Color get gray400 => const Color(0xFFC4C4C4);

  Color get gray40001 => const Color(0xFFB9B9B9);

  Color get gray50 => const Color(0xFFFDFBF9);

  Color get gray500 => const Color(0xFF949BA5);

  Color get gray50001 => const Color(0xFF9A9FA5);

  Color get gray5001 => const Color(0xFFFBFBFB);

  Color get gray5099 => const Color(0x99F5F8FC);

  Color get gray600 => const Color(0xFF686777);

  Color get gray60001 => const Color(0xFF696F79);

  Color get gray60002 => const Color(0xFF6F767D);

  Color get gray700 => const Color(0xFFffffff);

  Color get gray900 => const Color(0xFF202020);

  Color get gray90001 => const Color(0xFF1A1D1F);

  Color get gray90002 => const Color(0xFF202226);

  Color get gray => Colors.grey;

  // Transparent
  Color get transparent => Colors.transparent;

  // Indigo
  Color get indigo300 => const Color(0xFF706FE5);

  Color get indigo30001 => const Color(0xFF7879F1);

  Color get indigoA200 => const Color(0xFF5D5FEF);

  Color get indigoA400 => const Color(0xFF554AF0);

  // LightGreen
  Color get lightGreen300 => const Color(0xFF99FF82);

  // Lime
  Color get lime200 => const Color(0xFFE5FFA3);

  Color get limeA200 => const Color(0xFFD8F542);

  // Red
  Color get red100 => const Color(0xFFFFD5DB);

  Color get red500 => const Color(0xFFEA4335);

  Color get redA200 => const Color(0xFFFF5959);

  // White
  Color get whiteA700 => const Color(0xFF1C114D);

  Color get blueLightModeToBlack => const Color(0xFF100841);

  Color get blueLightModeToWhite => const Color(0xFF100841);

  Color get whiteLightModeToBlock => const Color(0xFFFFFFFF);

  Color get gradientShade4LightModeToBlock => const Color(0xFF9ACDE4);

  // Yellow
  Color get yellow400 => const Color(0xFFFFED54);

  Color get yellow => const Color(0xFFFFAF00);
}

class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFF000000),
    primaryContainer: Color(0xFF191A2C),
    secondaryContainer: Color(0xFF1977F3),
    errorContainer: Color(0xFF979797),
    onError: Color(0xFFE7E7E7),
    onPrimary: Color(0xFF2F2924),
    onPrimaryContainer: Color(0xFFffffff),
  );

  static const darkCodeColorScheme = ColorScheme.dark(
    primary: Color(0xFF000000),
    primaryContainer: Color(0xFF1A1A1A),
    secondaryContainer: Color(0xFF303030),
    errorContainer: Color(0xFF5A5A5A),
    onError: Color(0xFFB1B1B1),
    onPrimary: Color(0xFFE1E1E1),
    onPrimaryContainer: Color(0xFF000000),
  );
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
      bodyLarge: TextStyle(
        color: appTheme.whiteA700,
        fontSize: 18.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: appTheme.gray500,
        fontSize: 14.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: appTheme.gray60002,
        fontSize: 12.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w400,
      ),
      displayLarge: TextStyle(
        color: colorScheme.primary,
        fontSize: 60.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: colorScheme.primary,
        fontSize: 50.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w300,
      ),
      headlineLarge: TextStyle(
        color: colorScheme.primaryContainer,
        fontSize: 32.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: appTheme.whiteA700,
        fontSize: 24.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        color: appTheme.blueGray900.withOpacity(0.5),
        fontSize: 12.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: appTheme.whiteA700,
        fontSize: 22.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: appTheme.gray60001,
        fontSize: 16.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: appTheme.gradientShade4,
        fontSize: 14.sh,
        fontFamily: 'LamaSans',
        fontWeight: FontWeight.w600,
      ));
}

///
