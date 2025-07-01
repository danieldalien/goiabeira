import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/0_Core/Validators/decimal_input_formatter.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/custom_formatted_text_field.dart';

class PriceInput extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final Function(String) onChanged;
  const PriceInput({
    required this.onChanged,
    this.initialValue,
    this.labelText = 'Enter Price',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFormattedTextField(
      labelText: labelText,
      hintText: 'Ex: 25,5 €',
      onChanged: _onChanged,
      autovalidateMode: AutovalidateMode.always,

      showLabelAlways: true,
      initialValue: initialValue,
      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
    );
  }

  ///
  void _onChanged(String value) {
    onChanged(value);
  }
}
