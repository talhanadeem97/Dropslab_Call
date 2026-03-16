/// Typography definitions from Sense design system.
/// Provides two text theme variants:
/// - `textTheme`: Standard Material text styles with Sense-specific weights/sizes
/// - `textThemeScale(context)`: Responsive text styles that scale with MediaQuery
///
/// Both variants follow Material 3 naming: display, headline, title, body, label
/// in Large, Medium, Small sizes.
import 'package:flutter/material.dart';
import 'package:dropslab_call/theme/color_scheme.dart';

/// Standard text theme — fixed sizes matching Sense's mobile text theme.
/// Used as the default in ThemeData.textTheme.
TextTheme get textTheme => TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 57),
      displayMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 45),
      displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 36),
      headlineLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 32),
      headlineMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
      headlineSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
      titleLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      titleSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      labelLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      labelMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      labelSmall: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: onSurfaceVariantColor),
    );

/// Responsive text theme — sizes from Sense's `textThemeScale`, with
/// line height ratios for better readability at varying screen sizes.
/// Can be used in place of `textTheme` when responsive scaling is needed.
TextTheme textThemeScale(BuildContext context) => TextTheme(
      displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, height: 1.2),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 1.25),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, height: 1.3),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.35),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.45),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4),
    );
