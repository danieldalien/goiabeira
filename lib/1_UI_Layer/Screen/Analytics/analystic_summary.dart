import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/data_chip.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/time_window_popup_menu.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';

class AnalysticSummary extends StatelessWidget {
  const AnalysticSummary({
    required this.model,
    required this.selectedTimeWindow,
    required this.onSelected,
    required this.items,
    this.onRefresh,
    super.key,
  });

  final AnalyzeModel model;
  final Function()? onRefresh;
  final TimeWindow selectedTimeWindow;
  final ValueChanged<TimeWindow> onSelected;
  final List<TimeWindow> items;

  static const _hGap = SizedBox(height: 12);
  static const _vGap = SizedBox(width: 12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest, // matches HighlightContainer
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Header ------------------------------------------------------
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: scheme.secondaryContainer,
                child: Icon(Icons.insights, color: scheme.onSecondaryContainer),
              ),
              title: Text('Overview', style: theme.textTheme.titleLarge),
              subtitle: Text(
                selectedTimeWindow.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Refresh',
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 8),
                  TimeWindowPopupMenu(
                    label: selectedTimeWindow.displayName,
                    color: scheme.secondary,
                    items: items,
                    onSelected: onSelected,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
            const SizedBox(height: 8),

            // ---- Body --------------------------------------------------------
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _MetricsGrid(model: model),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.model});
  final AnalyzeModel model;

  @override
  Widget build(BuildContext context) {
    // Responsive: use Wrap so it flows nicely on small/large screens.
    // (If you prefer a fixed grid: use GridView with shrinkWrap + NeverScrollableScrollPhysics)
    return LayoutBuilder(
      builder: (context, constraints) {
        // tweak spacing/line breaks by width
        final isWide = constraints.maxWidth >= 560;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width:
                      isWide
                          ? (constraints.maxWidth - 12) / 2
                          : double.infinity,
                  child: DataChip(
                    icon: Icons.store,
                    label: 'Total stock value',
                    value: model.totalStockValue.toStringAsFixed(2),
                  ),
                ),
                SizedBox(
                  width:
                      isWide
                          ? (constraints.maxWidth - 12) / 2
                          : double.infinity,
                  child: DataChip(
                    icon: Icons.inventory_2,
                    label: 'Total stock quantity',
                    value: '${model.totalStockQuantity}',
                  ),
                ),
                SizedBox(
                  width:
                      isWide
                          ? (constraints.maxWidth - 12) / 2
                          : double.infinity,
                  child: DataChip(
                    icon: Icons.shopping_cart,
                    label: 'Total sold value',
                    value: model.totalSoldValue.toStringAsFixed(2),
                  ),
                ),
                SizedBox(
                  width:
                      isWide
                          ? (constraints.maxWidth - 12) / 2
                          : double.infinity,
                  child: DataChip(
                    icon: Icons.attach_money,
                    label: 'Total profit',
                    value: model.totalProfit.toStringAsFixed(2),
                  ),
                ),
                SizedBox(
                  width:
                      isWide
                          ? (constraints.maxWidth - 12) / 2
                          : double.infinity,
                  child: DataChip(
                    icon: Icons.sell,
                    label: 'Total sold quantity',
                    value: '${model.totalSoldQuantity}',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
