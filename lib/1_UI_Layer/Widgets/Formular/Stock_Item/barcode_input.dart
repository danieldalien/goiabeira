import 'package:flutter/material.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/custom_formatted_text_field.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/barcode_scanner_widget.dart';

class BarcodeInput extends StatefulWidget {
  const BarcodeInput({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.controller, // optional: parent-managed controller
  });

  final String? initialValue;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  State<BarcodeInput> createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  late final bool _ownsController = widget.controller == null;
  late final TextEditingController _ctrl =
      widget.controller ??
      TextEditingController(text: widget.initialValue ?? '');

  @override
  void didUpdateWidget(covariant BarcodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If no external controller is provided and initialValue changes, sync it.
    if (_ownsController && oldWidget.initialValue != widget.initialValue) {
      _ctrl.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    if (_ownsController) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormattedTextField(
      controller: _ctrl, // <-- bind controller
      labelText: 'Enter Barcode',
      hintText: 'Ex: 1234567890123',
      onChanged: widget.onChanged, // still notify parent
      autovalidateMode: AutovalidateMode.disabled,
      showLabelAlways: true,
      showCameraButton: true,
      onCameraTap: _onCameraTap,
    );
  }

  Future<void> _onCameraTap() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );

    if (!mounted) return;
    if (result != null && result.isNotEmpty) {
      _ctrl.text = result; // <-- updates the UI immediately
      widget.onChanged(result); // <-- informs parent state
    }
  }
}
