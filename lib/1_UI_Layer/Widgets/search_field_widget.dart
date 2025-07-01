import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  const SearchFieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search…',
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SearchBar(
      controller: controller,
      hintText: hintText,
      leading: Icon(Icons.search, color: scheme.onSurfaceVariant),
      trailing:
          controller.text.isEmpty
              ? null
              : [
                IconButton(
                  icon: Icon(Icons.clear, color: scheme.onSurfaceVariant),
                  onPressed: () => controller.clear(),
                  tooltip: 'Clear search',
                ),
              ],
      onTap: () {}, // if you need to open a SearchView
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      elevation: WidgetStateProperty.all(0), // flat + surfaceTint
      backgroundColor: WidgetStateProperty.all(scheme.surfaceContainerHighest),
      side: WidgetStateProperty.all(
        BorderSide(color: scheme.outline, width: 1),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // defaults to the M3 56 dp height & 16 dp horizontal padding
    );
  }
}
