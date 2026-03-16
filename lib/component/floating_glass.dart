import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart' as sf;

class FloatingGlassView extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final bool backdropFilter;

  const FloatingGlassView({
    super.key,
    required this.child,
    this.borderRadius = 100,
    this.backgroundColor,
    this.backdropFilter = true,
  });

  @override
  Widget build(BuildContext ctx) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          enabled: backdropFilter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            color: backgroundColor,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: 1,
                color: Theme.of(ctx).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: child,
          ),
        ),
      );
}

class FloatingGlassButton extends StatelessWidget {
  final IconData sfIcon;
  final GestureTapCallback? onTap;
  final Color? iconColor;
  final bool isActive;
  final bool isEnabled;

  final Widget? subWidget;

  const FloatingGlassButton({
    super.key,
    required this.sfIcon,
    this.onTap,
    this.iconColor,
    this.isActive = false,
    this.isEnabled = true,
    this.subWidget,
  });

  @override
  Widget build(BuildContext ctx) => Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        type: MaterialType.transparency,
        child: Ink(
          color: isActive ? Theme.of(ctx).cardColor : null,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              alignment: Alignment.center,
              child: _buildContent(ctx),
            ),
          ),
        ),
      );

  Widget _buildContent(BuildContext context) {
    if (subWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          sf.SFIcon(
            sfIcon,
            color: iconColor,
            fontSize: 20,
          ),
          subWidget!,
        ],
      );
    }

    return Opacity(
      opacity: onTap == null ? 0.1 : 1.0,
      child: sf.SFIcon(
        sfIcon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        fontSize: 20,
      ),
    );
  }
}


