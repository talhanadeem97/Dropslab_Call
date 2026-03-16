/// Context extensions from Sense design system.
/// Provides convenient access to theme data via BuildContext,
/// reducing boilerplate when referencing colors, text styles, and sizes.
import 'package:flutter/material.dart';
import 'package:dropslab_call/theme/color_scheme.dart';

/// Extension on BuildContext for quick theme access.
/// Usage: context.theme, context.textTheme, context.themeExt, etc.
extension ContextExtension on BuildContext {
  /// Returns the current ThemeData.
  ThemeData get theme => Theme.of(this);

  /// Returns the CustomColors theme extension (nullable).
  CustomColors? get themeExt => theme.extension<CustomColors>();

  /// Returns the current IconThemeData.
  IconThemeData get iconTheme => IconTheme.of(this);

  /// Returns the current TextTheme.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the current ColorScheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the current MediaQueryData.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen size.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Returns the screen width.
  double get screenWidth => screenSize.width;

  /// Returns the screen height.
  double get screenHeight => screenSize.height;

  /// Returns whether the current theme is dark mode.
  bool get isDarkMode =>
      View.of(this).platformDispatcher.platformBrightness == Brightness.dark;

  /// Returns the status bar height.
  double get statusBarHeight => mediaQuery.viewPadding.top;

  /// Returns whether the keyboard is currently open.
  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;
}

/// Extension on double for creating spacing widgets.
/// Usage: 8.0.verticalSpace, 16.0.horizontalSpace
extension SpacingExtension on double {
  Widget get verticalSpace => SizedBox(height: this);
  Widget get horizontalSpace => SizedBox(width: this);
}
