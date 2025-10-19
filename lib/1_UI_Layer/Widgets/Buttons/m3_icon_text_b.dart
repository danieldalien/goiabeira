import 'package:flutter/material.dart';

class M3IconButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool rounded;

  const M3IconButton({
    required this.text,
    this.icon,
    this.onPressed,
    this.rounded = true,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rounded ? 12 : 0),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      child:
          icon != null
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
              : Text(text),
    );
  }
}
