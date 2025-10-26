import 'package:flutter/material.dart';
// import your scanner page (adjust the path)
// import 'package:goiabeira/1_UI_Layer/Widgets/barcode_scanner_widget.dart';

typedef ScanRequest = Future<String?> Function(BuildContext context);

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search…',

    // NEW (all optional)
    this.showScanButton = true,
    this.scanTooltip = 'Scan barcode',
    this.scanIcon = Icons.photo_camera,
    this.onScanRequest, // if null, uses a default Navigator.push to your scanner
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  // scan options
  final bool showScanButton;
  final String scanTooltip;
  final IconData scanIcon;
  final ScanRequest? onScanRequest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SearchBar(
      controller: controller,
      hintText: hintText,
      leading: Icon(Icons.search, color: scheme.onSurfaceVariant),

      // trailing buttons: [scan] [clear-if-has-text]
      trailing: [
        if (showScanButton)
          IconButton.filledTonal(
            tooltip: scanTooltip,
            onPressed: () => _handleScan(context),
            icon: Icon(scanIcon),
          ),
        if (controller.text.isNotEmpty)
          IconButton(
            tooltip: 'Clear search',
            icon: Icon(Icons.clear, color: scheme.onSurfaceVariant),
            onPressed: () {
              controller.clear();
              onChanged?.call('');
            },
          ),
      ],

      onTap: () {}, // no-op or open a SearchView
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(scheme.surfaceContainerHighest),
      side: WidgetStateProperty.all(
        BorderSide(color: scheme.outline, width: 1),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _handleScan(BuildContext context) async {
    // unfocus to avoid keyboard pops while navigating
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 80));

    // 1) let caller provide their own scan flow
    String? code;
    if (onScanRequest != null) {
      code = await onScanRequest!(context);
    } else {
      // 2) default: push your scanner page and await result
      // final result = await Navigator.push<String>(
      //   context,
      //   MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
      // );
      // code = result;
    }

    if (code != null && code.isNotEmpty) {
      controller.text = code; // updates the UI
      onChanged?.call(code); // notifies parent
    }
  }
}
