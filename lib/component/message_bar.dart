import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart' as sf;

class MessageBarButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool isEnabled;

  const MessageBarButton({super.key, this.isEnabled = true, this.onTap});

  @override
  Widget build(BuildContext ctx) => ClipOval(
    child: Material(
      color: isEnabled
          ? Theme.of(ctx).colorScheme.primary
          : Theme.of(ctx).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: const sf.SFIcon(sf.SFIcons.sf_arrow_up, color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

class MessageBar extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final bool readOnly;
  final bool obscureText;
  final String? prefixText;
  final String? suffixText;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? textInputType;
  final VoidCallback? onTap;


  const MessageBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hint,
    this.readOnly = false,
    this.obscureText = false,
    this.prefixText,
    this.suffixText,
    this.suffix,
    this.prefix,
    this.textInputType,
    this.onTap
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Theme.of(context).inputDecorationTheme.fillColor, borderRadius: BorderRadius.circular(25)),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            readOnly: readOnly,
            obscureText: obscureText,
            keyboardType: textInputType,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              prefixText: prefixText,
              suffixText: suffixText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              isDense: true,
              prefixIconConstraints: BoxConstraints.tight(Size(20, 20)),
              prefixIcon: prefix,
              suffixIconConstraints: BoxConstraints.tight(Size(20, 20)),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    ),
  );
}
