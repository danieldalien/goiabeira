import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/data_chip.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/time_window_popup_menu.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';

class AnalysticSummary extends StatelessWidget {
  final Function()? onRefresh;
  final TimeWindow selectedTimeWindow;
  final ValueChanged<TimeWindow> onSelected;
  final List<TimeWindow> items;

  const AnalysticSummary({
    required this.model,
    required this.selectedTimeWindow,
    required this.onSelected,
    required this.items,
    this.onRefresh,
    super.key,
  });

  final AnalyzeModel model;

  static const _gap = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0, // flat per M3
      surfaceTintColor: scheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TimeWindowPopupMenu(
                  label: selectedTimeWindow.displayName,
                  color: scheme.secondary,
                  items: items,
                  onSelected: onSelected,
                ),
              ],
            ),
            _gap,
            DataChip(
              icon: Icons.store,
              label: 'Total stock value',
              value: model.totalStockValue.toStringAsFixed(2),
            ),
            DataChip(
              icon: Icons.inventory_2,
              label: 'Total stock quantity',
              value: '${model.totalStockQuantity}',
            ),
            DataChip(
              icon: Icons.shopping_cart,
              label: 'Total sold value',
              value: (model.totalSoldValue).toStringAsFixed(2),
            ),
            DataChip(
              icon: Icons.attach_money,
              label: 'Total profit',
              value: (model.totalProfit).toStringAsFixed(2),
            ),
            DataChip(
              icon: Icons.sell,
              label: 'Total sold quantity',
              value: '${model.totalSoldQuantity}',
            ),
            DataChip(
              icon: Icons.trending_up,
              label: 'Profit this week',
              value: (model.profitThisWeek).toStringAsFixed(2),
            ),
            DataChip(
              icon: Icons.calendar_month,
              label: 'Profit this month',
              value: (model.profitThisMonth).toStringAsFixed(2),
            ),
            const Divider(height: 32),
            Center(
              child: FilledButton.icon(
                onPressed: onRefresh,

                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
