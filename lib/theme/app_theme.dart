import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropslab_call/theme/color_scheme.dart';
import 'package:dropslab_call/theme/text_themes.dart';

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: onPrimaryColor,
  primaryContainer: primaryContainerColor,
  onPrimaryContainer: onPrimaryContainerColor,
  secondary: secondaryColor,
  onSecondary: onSecondaryColor,
  secondaryContainer: secondaryContainerColor,
  onSecondaryContainer: onSecondaryContainerColor,
  tertiary: tertiaryColor,
  onTertiary: onTertiaryColor,
  tertiaryContainer: tertiaryContainerColor,
  onTertiaryContainer: onTertiaryContainerColor,
  error: errorColor,
  onError: onErrorColor,
  errorContainer: errorContainerColor,
  surfaceBright: surfaceColor1,
  surface: surfaceColor,
  onSurface: onSurfaceColor,
  surfaceContainerHighest: surfaceVariantColor,
  surfaceContainerLow: surfaceContainerLowColor,
  onSurfaceVariant: onSurfaceVariantColor,
  outline: outlineColor,
  outlineVariant: outlineVariantColor,
  inverseSurface: inverseSurfaceColor,
  onInverseSurface: onInverseSurfaceColor,
  inversePrimary: inversePrimaryColor,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: darkPrimaryColor,
  onPrimary: darkOnPrimaryColor,
  primaryContainer: darkPrimaryContainerColor,
  onPrimaryContainer: darkOnPrimaryContainerColor,
  secondary: darkSecondaryColor,
  onSecondary: darkOnSecondaryColor,
  secondaryContainer: darkSecondaryContainerColor,
  onSecondaryContainer: darkOnSecondaryContainerColor,
  tertiary: darkTertiaryColor,
  onTertiary: darkOnTertiaryColor,
  tertiaryContainer: darkTertiaryContainerColor,
  onTertiaryContainer: darkOnTertiaryContainerColor,
  error: darkErrorColor,
  onError: darkOnErrorColor,
  errorContainer: darkErrorContainerColor,
  surface: darkSurfaceColor,
  onSurface: darkOnSurfaceColor,
  surfaceBright: darkSurfaceColor1,
  surfaceContainerHighest: darkSurfaceVariantColor,
  surfaceContainerLow: darkSurfaceContainerLowColor,
  onSurfaceVariant: darkOnSurfaceVariantColor,
  outline: darkOutlineColor,
  outlineVariant: darkOutlineVariantColor,
  inverseSurface: darkInverseSurfaceColor,
  onInverseSurface: darkOnInverseSurfaceColor,
  inversePrimary: darkInversePrimaryColor,
);

ColorScheme senseColorScheme = ColorScheme.light(
  primary: Color(0xff00A294),
  onPrimary: Colors.white,
  surfaceContainerLow: Color(0xffEEEEEE),
  onSurfaceVariant: Color(0xff444748),
  outlineVariant: Color(0xffE0E3E3),
  outline: Color(0xffC4C7C8),
  secondaryContainer: Color(0xffF0F0F0),
  onSecondaryContainer: Color(0xFF71787D),
  onSurface: Color(0xff1C1B1B),
);

ThemeData buildTheme({required bool isLight}) {
  return isLight ? _buildLightTheme() : _buildDarkTheme();
}

ThemeData _buildLightTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: senseColorScheme,
      scaffoldBackgroundColor: Color(0xFFFCFCFC),
      extensions: <ThemeExtension<CustomColors>>[
        CustomColors(
          success: success,
          successContainer: successContainer,
          low: low,
          medium: medium,
          high: high,
          open: open,
          onHold: onHold,
          inProgress: inProgress,
          done: done,
          customSurfaceContainer: surfaceColor2,
          customBtnBg: customBtnBg,
        ),
      ],
      textTheme: textTheme,
      timePickerTheme: TimePickerThemeData(
        dayPeriodColor: senseColorScheme.primary,
      ),
      disabledColor: senseColorScheme.onSecondaryContainer.withValues(alpha: 0.5),
      dividerTheme: DividerThemeData(color: senseColorScheme.surfaceContainerLow),
      appBarTheme: AppBarTheme(
        shadowColor: senseColorScheme.surfaceContainerLow,
        backgroundColor: senseColorScheme.onPrimary,
        surfaceTintColor: senseColorScheme.onPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: senseColorScheme.onPrimary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: senseColorScheme.primary,
        foregroundColor: senseColorScheme.onPrimary,
        extendedSizeConstraints: BoxConstraints(minHeight: 48, maxHeight: 48),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: senseColorScheme.primary,
          foregroundColor: senseColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          maximumSize: Size(double.maxFinite, 48),
          minimumSize: Size(double.maxFinite, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: senseColorScheme.primary,
          side: BorderSide(color: senseColorScheme.primary),
          maximumSize: Size(double.maxFinite, 48),
          minimumSize: Size(double.maxFinite, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: senseColorScheme.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: senseColorScheme.surfaceContainerLow,
        selectedColor: senseColorScheme.primary,
        secondarySelectedColor: senseColorScheme.primaryContainer,
        labelStyle: TextStyle(color: senseColorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: senseColorScheme.onPrimaryContainer),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: senseColorScheme.outline),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xff00A294),
        selectionColor: Color(0xff00A294).withValues(alpha: 0.4),
        selectionHandleColor: Color(0xff00A294),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: senseColorScheme.secondaryContainer,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        prefixIconColor: senseColorScheme.onSecondaryContainer,
        suffixIconColor: senseColorScheme.onSecondaryContainer,
        hintStyle: textTheme.bodyLarge?.copyWith(color: senseColorScheme.onSecondaryContainer),
      ),
    );

ThemeData _buildDarkTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      extensions: <ThemeExtension<CustomColors>>[
        CustomColors(
          success: success,
          successContainer: successContainer,
          low: low,
          medium: medium,
          high: high,
          open: open,
          onHold: onHold,
          inProgress: inProgress,
          done: done,
          customSurfaceContainer: darkSurfaceColor2,
          customBtnBg: customBtnBg,
        ),
      ],
      textTheme: textTheme,
      scaffoldBackgroundColor: darkBackgroundColor,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: darkColorScheme.surface,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: darkColorScheme.onSecondaryContainer),
        titleTextStyle: TextStyle(
          color: darkColorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.tertiary,
        foregroundColor: darkColorScheme.onTertiaryContainer,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          maximumSize: Size(double.maxFinite, 48),
          minimumSize: Size(double.maxFinite, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.surfaceContainerLow,
        selectedColor: darkColorScheme.primary,
        secondarySelectedColor: darkColorScheme.primaryContainer,
        labelStyle: TextStyle(color: darkColorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: darkColorScheme.onPrimaryContainer),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: darkColorScheme.outline),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: darkColorScheme.surfaceContainerLow,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: darkColorScheme.onSurface),
        ),
        indicatorColor: darkColorScheme.secondaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerLow,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkColorScheme.primary, width: 1.5),
        ),
        prefixIconColor: darkColorScheme.onSurfaceVariant,
        suffixIconColor: darkColorScheme.onSurfaceVariant,
        hintStyle: textTheme.bodyLarge?.copyWith(color: darkColorScheme.onSurfaceVariant),
      ),
    );
