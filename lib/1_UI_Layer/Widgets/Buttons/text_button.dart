import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final void Function()? onTap;
  final bool border;
  final TextStyle textStyle;
  final Color? borderColor;
  final double padding;
  const MyTextButton(
      {required this.text,
      required this.backgroundColor,
      this.onTap,
      this.border = false,
      required this.textStyle,
      this.borderColor,
      this.padding = 0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border
            ? Border.all(color: borderColor ?? Colors.transparent)
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
