import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/custom_formatted_text_field.dart';

class QuantityInput extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;
  const QuantityInput({required this.onChanged, this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFormattedTextField(
      labelText: 'Enter Quantity',
      hintText: 'Ex: 2',
      onChanged: _onChanged,
      autovalidateMode: AutovalidateMode.always,
      //textStyle: AppTextStyle.defaultText,
      //labelTextStyle: TextStyle(color: AppColors.primaryWhite),
      //focusedBorderColor: AppColors.focusedBorderColor,
      //unfocusedBorderColor: AppColors.unfocusedBorderColor,
      //floatingLabelStyle: TextStyle(color: AppColors.floatingTextLabel),
      showLabelAlways: true,
      initialValue: initialValue,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  ///
  void _onChanged(String value) {
    onChanged(value);
  }
}
