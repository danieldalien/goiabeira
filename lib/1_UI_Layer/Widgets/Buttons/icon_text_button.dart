import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final void Function()? onTap;
  final bool border;
  final TextStyle textStyle;
  final Color? iconColor;
  final Color? borderColor;
  final double padding;

  const IconTextButton(
      {required this.text,
      required this.icon,
      required this.backgroundColor,
      this.onTap,
      this.border = false,
      required this.textStyle,
      this.iconColor,
      this.borderColor,
      this.padding = 5,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border
            ? Border.all(color: borderColor ?? Colors.transparent)
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor ?? textStyle.color,
              size: 1.68 * textStyle.fontSize!,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
