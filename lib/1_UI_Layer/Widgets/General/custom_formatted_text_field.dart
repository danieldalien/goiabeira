import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A Material-3 aware text-field with
/// – custom input formatters
/// – dynamic border colour on focus
/// – optional always-visible label
class CustomFormattedTextField extends StatefulWidget {
  const CustomFormattedTextField({
    super.key,
    this.controller,
    this.inputFormatters = const [],
    this.onChanged,
    this.obscureText = false,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.decoration,
    this.labelText,
    this.hintText,
    this.textStyle,
    this.labelTextStyle,
    this.floatingLabelStyle,
    this.hintTextStyle,
    this.focusedBorderColor,
    this.unfocusedBorderColor,
    this.showLabelAlways = false,
    this.initialValue,
    this.minLines = 1,
    this.maxLines,
  });

  final TextEditingController? controller;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode autovalidateMode;
  final InputDecoration? decoration;

  // convenience props
  final String? labelText;
  final String? hintText;

  // styles
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? hintTextStyle;

  // colours
  final Color? focusedBorderColor;
  final Color? unfocusedBorderColor;

  // misc
  final bool showLabelAlways;
  final String? initialValue;
  final int minLines;
  final int? maxLines;

  @override
  State<CustomFormattedTextField> createState() =>
      _CustomFormattedTextFieldState();
}

class _CustomFormattedTextFieldState extends State<CustomFormattedTextField> {
  late final TextEditingController _ctrl =
      widget.controller ?? TextEditingController(text: widget.initialValue);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(12); // M3 medium radius

    // Fallback colours that respect the active theme
    final focusColour = widget.focusedBorderColor ?? scheme.primary;
    final unfocusedColour = widget.unfocusedBorderColor ?? scheme.outline;

    return TextFormField(
      controller: _ctrl,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onChanged: widget.onChanged,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      style: widget.textStyle,
      textInputAction: TextInputAction.done,
      decoration:
          widget.decoration ??
          InputDecoration(
            filled: true,
            fillColor: scheme.surfaceVariant, // spec default
            labelText: widget.labelText,
            labelStyle: widget.labelTextStyle,
            floatingLabelStyle:
                widget.floatingLabelStyle ?? TextStyle(color: focusColour),
            floatingLabelBehavior:
                widget.showLabelAlways
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.auto,
            hintText: widget.hintText,
            hintStyle:
                widget.hintTextStyle ??
                TextStyle(color: scheme.onSurfaceVariant),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: unfocusedColour),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: focusColour, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: scheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: scheme.error, width: 2),
            ),
          ),
    );
  }
}
