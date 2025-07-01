import 'package:flutter/services.dart';

/// Only allows input that parses to a double with up to [decimalRange] digits
/// after the decimal point.
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2})
    : assert(decimalRange >= 0, 'decimalRange must be >= 0');

  final _digitAndDotRegex = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // empty input is fine
    if (text.isEmpty) {
      return newValue;
    }

    // Must be only digits and at most one '.'
    if (!_digitAndDotRegex.hasMatch(text)) {
      return oldValue;
    }

    // If there's a '.', enforce max fractional digits
    if (text.contains('.')) {
      final parts = text.split('.');
      // more than one dot → reject
      if (parts.length > 2) return oldValue;

      // fraction too long → reject
      if (parts[1].length > decimalRange) {
        return oldValue;
      }
    }

    return newValue;
  }
}
