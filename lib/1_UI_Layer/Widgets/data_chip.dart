import 'package:flutter/material.dart';

class DataChip extends StatelessWidget {
  const DataChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      dense: true,
      leading: Icon(icon, color: scheme.primary),
      title: Text(label, style: textTheme.bodyMedium),
      trailing: Text(
        value,
        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
