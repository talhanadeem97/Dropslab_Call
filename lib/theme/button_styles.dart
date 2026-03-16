/// Button style definitions from Sense design system.
/// Provides reusable button configurations that match the Sense brand identity.
/// These styles are applied globally via ThemeData and can be used directly
/// for per-widget customization when needed.
import 'package:flutter/material.dart';
import 'package:dropslab_call/theme/dimens.dart';

/// Creates the standard elevated button style for the Sense theme.
/// - Full-width with fixed height (48px)
/// - Fully rounded corners (stadium shape)
/// - Primary color background with onPrimary text
ButtonStyle senseElevatedButtonStyle(ColorScheme colorScheme) {
  return ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    maximumSize: Size(double.maxFinite, Px.k48),
    minimumSize: Size(double.maxFinite, Px.k48),
  );
}

/// Creates the standard outlined button style for the Sense theme.
/// - Full-width with fixed height (48px)
/// - Primary-colored border and text
/// - Slightly rounded corners (4px) in light mode, stadium in dark mode
ButtonStyle senseOutlinedButtonStyle(ColorScheme colorScheme, {bool isDark = false}) {
  return OutlinedButton.styleFrom(
    foregroundColor: colorScheme.primary,
    side: BorderSide(color: isDark ? colorScheme.outline : colorScheme.primary),
    maximumSize: Size(double.maxFinite, Px.k48),
    minimumSize: Size(double.maxFinite, Px.k48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(isDark ? 100 : 4),
    ),
  );
}

/// Creates the standard text button style for the Sense theme.
/// - Primary-colored text, no background
ButtonStyle senseTextButtonStyle(ColorScheme colorScheme) {
  return TextButton.styleFrom(
    foregroundColor: colorScheme.primary,
  );
}
