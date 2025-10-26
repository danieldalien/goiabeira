import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';

class TimeWindowPopupMenu extends StatelessWidget {
  final String label;
  final Color color;
  final List<TimeWindow> items;
  final ValueChanged<TimeWindow> onSelected;

  const TimeWindowPopupMenu({
    super.key,
    required this.label,
    required this.color,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TimeWindow>(
      tooltip: 'Zeitraum wählen',
      onSelected: onSelected,
      itemBuilder:
          (context) => [
            for (final w in items)
              PopupMenuItem<TimeWindow>(value: w, child: Text(w.displayName)),
          ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}
