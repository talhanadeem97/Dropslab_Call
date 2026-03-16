import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart' as sf;


class CustomGlassButton extends StatelessWidget {
  final IconData sfIcon;
  final GestureTapCallback? onTap;
  final Color? iconColor;
  final bool isActive;
  final bool isEnabled;
  final double iconSize;


  const CustomGlassButton({
    super.key,
    required this.sfIcon,
    this.onTap,
    this.iconColor,
    this.isActive = false,
    this.isEnabled = true,
    this.iconSize = 20
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
        child: _buildContent(ctx),
      ),
    ),
  );

  Widget _buildContent(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.1 : 1.0,
      child: sf.SFIcon(
        sfIcon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        fontSize: iconSize,
      ),
    );
  }
}
