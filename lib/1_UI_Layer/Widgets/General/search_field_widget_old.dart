import 'package:flutter/material.dart';

class SearchFieldWidgetOld extends StatelessWidget {
  final TextEditingController controller;
  final Color? backgroundColor;
  final Color? textColor;
  final String? hintText;
  final Color? focusedBorderColor;
  final Color? unfocusedBorderColor;
  final double? borderRadius;
  final double? borderWidth;

  const SearchFieldWidgetOld({
    required this.controller,
    this.backgroundColor,
    this.textColor,
    this.hintText,
    this.focusedBorderColor,
    this.unfocusedBorderColor,
    this.borderRadius,
    this.borderWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Set default values to enhance UX/UI:
    // - Default background: white
    // - Default text: dark grey
    // - Default hint: 'Search...'
    // - Default focused border: primary color from the theme
    // - Default unfocused border: light grey
    // - Default border radius: 12.0
    // - Default border width: 1.5
    final bgColor = backgroundColor ?? Colors.white;
    final txtColor = textColor ?? Colors.black87;
    final hint = hintText ?? 'Search...';
    final focusColor = focusedBorderColor ?? Theme.of(context).primaryColor;
    final unfocusColor = unfocusedBorderColor ?? Colors.grey.shade300;
    final radius = borderRadius ?? 12.0;
    final bWidth = borderWidth ?? 1.5;

    return Container(
      // Container decoration with background color, border, rounded corners,
      // and a subtle box shadow for elevation.
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: unfocusColor, width: bWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: txtColor),
        decoration: InputDecoration(
          // Prefix search icon for better visual cue.
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: hint,
          hintStyle: TextStyle(color: txtColor.withValues(alpha: 0.6)),
          // Remove the default border to use our custom one.
          border: InputBorder.none,
          // Add content padding for improved tap target and spacing.
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
          // Define a focused border that uses the default values.
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusColor, width: bWidth),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
