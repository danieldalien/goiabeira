import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final void Function()? onTap;
  final Color? borderColor;

  // Constructor
  const RoundIconButton({
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 20,
    this.onTap,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: BorderSide(width: 2, color: borderColor ?? Colors.transparent),
        padding: const EdgeInsets.all(16), // Adjust the padding as needed
        backgroundColor: backgroundColor, // Button background color
      ),
      child: Icon(
        icon,
        color: iconColor, // Icon color
        size: iconSize, // Icon size
      ),
    );
  }
}
