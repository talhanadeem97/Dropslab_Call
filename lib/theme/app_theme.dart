/// Main theme configuration for the Dropslab Call app.
/// Integrates the Sense design system's ThemeData, including:
/// - Material 3 color scheme (light and dark)
/// - Custom colors via ThemeExtension (status indicators, semantic colors)
/// - Typography from Sense text theme
/// - Component styles: buttons, app bars, input fields, chips, FABs, etc.
///
/// Entry point: `buildTheme(isLight: true/false)` — used by MaterialApp.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropslab_call/theme/color_scheme.dart';
import 'package:dropslab_call/theme/text_themes.dart';
import 'package:dropslab_call/theme/dimens.dart';

// ---------------------------------------------------------------------------
// Light color scheme — mirrors Sense's `lightColorScheme` exactly
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Dark color scheme — mirrors Sense's `darkColorScheme` exactly
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Simplified color scheme — used by Sense's `lightTheme` for quick reference
// Provides the primary teal (#00A294) with essential surface/outline overrides
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Public API — called from MaterialApp in main.dart
// ---------------------------------------------------------------------------

/// Builds the complete ThemeData for either light or dark mode.
/// This is the single entry point used by `MaterialApp.theme` and
/// `MaterialApp.darkTheme`.
ThemeData buildTheme({required bool isLight}) {
  return isLight ? _buildLightTheme() : _buildDarkTheme();
}

// ---------------------------------------------------------------------------
// Light theme — full Sense design system configuration
// ---------------------------------------------------------------------------
ThemeData _buildLightTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: senseColorScheme,
      scaffoldBackgroundColor: const Color(0xFFFCFCFC),

      // Custom semantic colors (status indicators, etc.)
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

      // Typography from Sense text theme
      textTheme: textTheme,

      // TimePicker: primary color for day period toggle
      timePickerTheme: TimePickerThemeData(
        dayPeriodColor: senseColorScheme.primary,
      ),

      // Disabled state color
      disabledColor: senseColorScheme.onSecondaryContainer.withValues(alpha: 0.5),

      // Divider: uses surfaceContainerLow for subtle separation
      dividerTheme: DividerThemeData(color: senseColorScheme.surfaceContainerLow),

      // AppBar: white background with subtle shadow, dark status bar icons
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

      // FAB: primary teal background, white icon
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: senseColorScheme.primary,
        foregroundColor: senseColorScheme.onPrimary,
        extendedSizeConstraints: BoxConstraints(minHeight: Px.k48, maxHeight: Px.k48),
      ),

      // Elevated button: full-width stadium shape, primary color, 48px height
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: senseColorScheme.primary,
          foregroundColor: senseColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          maximumSize: Size(double.maxFinite, Px.k48),
          minimumSize: Size(double.maxFinite, Px.k48),
        ),
      ),

      // Outlined button: primary border, slight corner radius
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: senseColorScheme.primary,
          side: BorderSide(color: senseColorScheme.primary),
          maximumSize: Size(double.maxFinite, Px.k48),
          minimumSize: Size(double.maxFinite, Px.k48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),

      // Text button: primary-colored text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: senseColorScheme.primary,
        ),
      ),

      // Chip: rounded with outline border, Sense color scheme
      chipTheme: ChipThemeData(
        backgroundColor: senseColorScheme.surfaceContainerLow,
        selectedColor: senseColorScheme.primary,
        secondarySelectedColor: senseColorScheme.primaryContainer,
        labelStyle: TextStyle(color: senseColorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: senseColorScheme.onPrimaryContainer),
        padding: EdgeInsets.symmetric(horizontal: Px.k8, vertical: Px.k4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: senseColorScheme.outline),
        ),
      ),

      // Text selection: teal cursor and selection handles
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xff00A294),
        selectionColor: const Color(0xff00A294).withValues(alpha: 0.4),
        selectionHandleColor: const Color(0xff00A294),
      ),

      // Input fields: filled with secondary container color, no visible border
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

      // Navigation bar: matching Sense light theme styling
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: senseColorScheme.surfaceContainerLow,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: senseColorScheme.onSurface),
        ),
        indicatorColor: senseColorScheme.secondaryContainer,
      ),
    );

// ---------------------------------------------------------------------------
// Dark theme — full Sense design system configuration (dark variant)
// ---------------------------------------------------------------------------
ThemeData _buildDarkTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,

      // Same custom colors as light (semantic status colors stay consistent)
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

      // Typography from Sense text theme
      textTheme: textTheme,

      // Dark scaffold background
      scaffoldBackgroundColor: darkBackgroundColor,

      // AppBar: dark surface with light status bar icons, bold title
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

      // FAB: tertiary color in dark mode
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.tertiary,
        foregroundColor: darkColorScheme.onTertiaryContainer,
      ),

      // Elevated button: same stadium shape, dark primary color
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          maximumSize: Size(double.maxFinite, Px.k48),
          minimumSize: Size(double.maxFinite, Px.k48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),

      // Outlined button: outline-colored border, stadium shape
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),

      // Text button: primary-colored text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
        ),
      ),

      // Chip: dark surface with outline border
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.surfaceContainerLow,
        selectedColor: darkColorScheme.primary,
        secondarySelectedColor: darkColorScheme.primaryContainer,
        labelStyle: TextStyle(color: darkColorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: darkColorScheme.onPrimaryContainer),
        padding: EdgeInsets.symmetric(horizontal: Px.k8, vertical: Px.k4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: darkColorScheme.outline),
        ),
      ),

      // Navigation bar: dark surface, matching Sense dark theme
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: darkColorScheme.surfaceContainerLow,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: darkColorScheme.onSurface),
        ),
        indicatorColor: darkColorScheme.secondaryContainer,
      ),

      // Input fields: dark surface fill, primary-colored focus border
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
