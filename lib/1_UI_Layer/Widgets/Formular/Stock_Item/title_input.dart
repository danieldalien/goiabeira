import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/custom_formatted_text_field.dart';

class TitleInput extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;
  const TitleInput({required this.onChanged, this.initialValue, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFormattedTextField(
      labelText: 'Enter Title',
      hintText: 'Ex: Saphier-Ring',
      onChanged: _onChanged,
      autovalidateMode: AutovalidateMode.disabled,

      showLabelAlways: true,
      initialValue: initialValue,
    );
  }

  ///
  void _onChanged(String value) {
    onChanged(value);
  }
}
