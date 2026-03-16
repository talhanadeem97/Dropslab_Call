/// Main theme configuration for the Dropslab Call app.
/// Integrates the Sense design system's ThemeData, including:
/// - Material 3 color scheme (light and dark)
/// - Custom colors via ThemeExtension (status indicators, semantic colors)
/// - Typography from Sense text theme
/// - Component styles via button_styles.dart: buttons, app bars, input fields, chips, FABs
///
/// Color scheme strategy:
/// - `senseColorScheme` is the canonical light color scheme, matching Sense's
///   `colorScheme` variable used in `lightTheme()`. It applies the primary teal
///   (#00A294) with essential surface/outline overrides.
/// - `darkColorScheme` is the full dark palette from Sense.
///
/// Entry point: `buildTheme(isLight: true/false)` — used by MaterialApp.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropslab_call/theme/color_scheme.dart';
import 'package:dropslab_call/theme/text_themes.dart';
import 'package:dropslab_call/theme/dimens.dart';
import 'package:dropslab_call/theme/button_styles.dart';

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
// Canonical light color scheme — matches Sense's `colorScheme` variable
// used in `lightTheme()`. Applies the brand teal (#00A294) as primary.
// ---------------------------------------------------------------------------
final ColorScheme senseColorScheme = ColorScheme.light(
  primary: sensesPrimaryTeal,
  onPrimary: onPrimaryColor,
  surfaceContainerLow: Color(0xffEEEEEE),
  onSurfaceVariant: onSurfaceVariantColor,
  outlineVariant: outlineVariantColor,
  outline: Color(0xffC4C7C8),
  secondaryContainer: Color(0xffF0F0F0),
  onSecondaryContainer: Color(0xFF71787D),
  onSurface: onSurfaceColor,
);

/// Sense brand primary teal — used across both light and dark themes
const Color sensesPrimaryTeal = Color(0xff00A294);

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
      scaffoldBackgroundColor: backgroundColor,

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

      // Button styles — reused from button_styles.dart (Sense design system)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: senseElevatedButtonStyle(senseColorScheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: senseOutlinedButtonStyle(senseColorScheme),
      ),
      textButtonTheme: TextButtonThemeData(
        style: senseTextButtonStyle(senseColorScheme),
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
        cursorColor: sensesPrimaryTeal,
        selectionColor: sensesPrimaryTeal.withValues(alpha: 0.4),
        selectionHandleColor: sensesPrimaryTeal,
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

      // Button styles — reused from button_styles.dart (Sense design system)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: senseElevatedButtonStyle(darkColorScheme),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: senseOutlinedButtonStyle(darkColorScheme, isDark: true),
      ),
      textButtonTheme: TextButtonThemeData(
        style: senseTextButtonStyle(darkColorScheme),
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
