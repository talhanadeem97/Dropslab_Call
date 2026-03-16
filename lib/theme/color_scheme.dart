/// Color scheme definitions from Sense design system.
/// Contains:
/// - CustomColors ThemeExtension for semantic/status colors
/// - Light theme color constants (primary: #353636 for neutral scheme)
/// - Dark theme color constants
/// - Custom status colors (success, warning, error, progress states)
///
/// The primary brand color (#00A294 teal) is applied via `senseColorScheme`
/// in app_theme.dart, while these constants define the full Material 3 palette.
import 'package:flutter/material.dart';

/// ThemeExtension providing additional semantic colors beyond Material's
/// built-in ColorScheme. Accessible via `Theme.of(context).extension<CustomColors>()`.
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? success;
  final Color? successContainer;
  final Color? customSurfaceContainer;
  final Color? medium;
  final Color? low;
  final Color? high;
  final Color? onHold;
  final Color? open;
  final Color? inProgress;
  final Color? done;
  final Color? customBtnBg;

  const CustomColors({
    this.success,
    this.successContainer,
    this.customSurfaceContainer,
    this.medium,
    this.low,
    this.high,
    this.onHold,
    this.open,
    this.inProgress,
    this.done,
    this.customBtnBg,
  });

  @override
  CustomColors copyWith({
    Color? success,
    Color? successContainer,
    Color? customSurfaceContainer,
    Color? medium,
    Color? low,
    Color? high,
    Color? onHold,
    Color? open,
    Color? inProgress,
    Color? done,
    Color? customBtnBg,
  }) {
    return CustomColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      customSurfaceContainer: customSurfaceContainer ?? this.customSurfaceContainer,
      medium: medium ?? this.medium,
      low: low ?? this.low,
      high: high ?? this.high,
      onHold: onHold ?? this.onHold,
      open: open ?? this.open,
      inProgress: inProgress ?? this.inProgress,
      done: done ?? this.done,
      customBtnBg: customBtnBg ?? this.customBtnBg,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      customSurfaceContainer: Color.lerp(customSurfaceContainer, other.customSurfaceContainer, t),
      medium: Color.lerp(medium, other.medium, t),
      low: Color.lerp(low, other.low, t),
      high: Color.lerp(high, other.high, t),
      onHold: Color.lerp(onHold, other.onHold, t),
      open: Color.lerp(open, other.open, t),
      inProgress: Color.lerp(inProgress, other.inProgress, t),
      done: Color.lerp(done, other.done, t),
      customBtnBg: Color.lerp(customBtnBg, other.customBtnBg, t),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom semantic colors — used across both light and dark themes
// ---------------------------------------------------------------------------

/// Success state — maps to Sense's primary teal
const Color success = Color(0xff00a294);

/// Success container — light green background for success surfaces
const Color successContainer = Color(0xffBFF0B1);

/// White surface container for elevated cards
const Color customSurfaceContainer = Colors.white;

/// Warning/medium severity — orange
const Color medium = Color(0xffDF7202);

/// Low severity — green
const Color low = Color(0xff388e3c);

/// High severity/urgent — red
const Color high = Color(0xffd32f2f);

/// On-hold status — amber/orange
const Color onHold = Color(0xffF6A746);

/// Open/active status — blue
const Color open = Color(0xff1565C0);

/// In-progress status — blue (same as open)
const Color inProgress = Color(0xff1565C0);

/// Completed/done status — green
const Color done = Color(0xff388e3c);

/// Custom button background — semi-transparent grey
Color customBtnBg = const Color(0xffEBE7E7).withValues(alpha: 0.6);

// ---------------------------------------------------------------------------
// Light theme color palette
// ---------------------------------------------------------------------------

/// Primary neutral — dark grey used in light theme's full ColorScheme
const Color primaryColor = Color(0xFF353636);
const Color onPrimaryColor = Colors.white;
const Color primaryContainerColor = Color(0xFF585858);
const Color onPrimaryContainerColor = Color(0xFFFDFFFF);

/// Secondary — medium grey
const Color secondaryColor = Color(0xFF5D5E5F);
const Color onSecondaryColor = Colors.white;
const Color secondaryContainerColor = Color(0xFFD2D2D2);
const Color onSecondaryContainerColor = Color(0xFF3D3E3E);

/// Tertiary — muted purple
const Color tertiaryColor = Color(0xFF5F5791);
const Color onTertiaryColor = Colors.white;
const Color tertiaryContainerColor = Color(0xFFE5DEFF);
const Color onTertiaryContainerColor = Color(0xFF473F77);

/// Error — Material red
const Color errorColor = Color(0xFFBA1A1A);
const Color onErrorColor = Colors.white;
const Color errorContainerColor = Color(0xFFFFDAD6);
const Color onErrorContainerColor = Color(0xFF410002);

/// Background
const Color backgroundColor = Color(0xFFFFFFFF);

/// Surface — warm off-white with primary-tinted surface levels
const Color surfaceColor = Color(0xFFFCF8F8);
const Color surfaceColor1 = Color(0x0C00A294);
const Color surfaceColor2 = Color(0xFFF6F3F2);
const Color surfaceColor3 = Color(0x1C00A294);
const Color surfaceColor4 = Color(0x1E00A294);
const Color surfaceColor5 = Color(0x2300A294);
const Color onSurfaceColor = Color(0xFF1C1B1B);

/// Surface variant and outline
const Color surfaceVariantColor = Color(0xFFE0E3E3);
const Color onSurfaceVariantColor = Color(0xFF444748);
const Color outlineColor = Color(0xFF747878);
const Color outlineVariantColor = Color(0xFFE0E3E3);

/// Inverse colors
const Color inverseSurfaceColor = Color(0xFF313030);
const Color onInverseSurfaceColor = Color(0xFFF4F0EF);
const Color inversePrimaryColor = Color(0xFFC8C6C6);
const Color surfaceContainerLowColor = Color(0x145E5E5E);

// ---------------------------------------------------------------------------
// Dark theme color palette
// ---------------------------------------------------------------------------

/// Dark primary — light grey on dark backgrounds
const Color darkPrimaryColor = Color(0xFFC8C6C6);
const Color darkOnPrimaryColor = Color(0xFF303030);
const Color darkPrimaryContainerColor = Color(0xFF3F3F3F);
const Color darkOnPrimaryContainerColor = Color(0xFFD5D4D3);

/// Dark secondary
const Color darkSecondaryColor = Color(0xFFF1F0F0);
const Color darkOnSecondaryColor = Color(0xFF2F3131);
const Color darkSecondaryContainerColor = Color(0xFFC6C6C6);
const Color darkOnSecondaryContainerColor = Color(0xFF353636);

/// Dark tertiary — lavender
const Color darkTertiaryColor = Color(0xFFC8BFFF);
const Color darkOnTertiaryColor = Color(0xFF30285F);
const Color darkTertiaryContainerColor = Color(0xFF473F77);
const Color darkOnTertiaryContainerColor = Color(0xFFE5DEFF);

/// Dark error
const Color darkErrorColor = Color(0xFFFFB4AB);
const Color darkOnErrorColor = Color(0xFF690005);
const Color darkErrorContainerColor = Color(0xFF93000A);
const Color darkOnErrorContainerColor = Color(0xFFFFDAD6);

/// Dark background and surface
const Color darkBackgroundColor = Color(0xFF141313);
const Color darkSurfaceColor = Color(0xFF141313);
const Color darkSurfaceColor1 = Color(0x0C44DCCA);
const Color darkSurfaceColor2 = Color(0xFF1C1B1B);
const Color darkSurfaceColor3 = Color(0x1C44DCCA);
const Color darkSurfaceColor4 = Color(0x1E44DCCA);
const Color darkSurfaceColor5 = Color(0x2344DCCA);
const Color darkOnSurfaceColor = Color(0xFFE5E2E1);

/// Dark surface variant and outline
const Color darkSurfaceVariantColor = Color(0xFF444748);
const Color darkOnSurfaceVariantColor = Color(0xFFC4C7C8);
const Color darkOutlineColor = Color(0xFF8E9192);
const Color darkOutlineVariantColor = Color(0xFF444748);

/// Dark inverse colors
const Color darkInverseSurfaceColor = Color(0xFFE5E2E1);
const Color darkOnInverseSurfaceColor = Color(0xFF313030);
const Color darkInversePrimaryColor = Color(0xFF5E5E5E);
const Color darkSurfaceContainerLowColor = Color(0x14C8C6C6);
