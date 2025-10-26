import 'package:flutter/material.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Service/stock_item_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';

class TopSellingItemCard extends StatelessWidget {
  final SoldItemSummaryModel summary;
  final VoidCallback? onTap;

  const TopSellingItemCard({super.key, required this.summary, this.onTap});

  @override
  Widget build(BuildContext context) {
    final item = summary.soldItem.stockItem;
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 1, // M3 keeps elevation subtle
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                item.title,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Leading image
                  Column(
                    children: [
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 64 * 2,
                          height: 64 * 2,
                          child: StockItemService.buildImageWidget(
                            item,
                            // Ensure your builder returns an Image with width/height + fit
                            // e.g. Image.file(file, width: 64, height: 64, fit: BoxFit.cover)
                          ),
                        ),
                      ),
                      // Secondary line
                      Text(
                        "Sold: ${summary.soldQuantity}",
                        style: text.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // KPIs – Wrap prevents horizontal overflow
                  Column(
                    spacing: 8,
                    // runSpacing: 8,
                    children: [
                      _MetricChip.elevated(
                        context,
                        label: "Revenue",
                        value: "${summary.totalRevenue.toStringAsFixed(2)} €",
                        // tonal = surfaceVariant blend with primary (M3)
                        foreground: cs.primary,
                        background: cs.primaryContainer.withOpacity(.25),
                      ),
                      _MetricChip.elevated(
                        context,
                        label: "Profit",
                        value: "${summary.totalProfit.toStringAsFixed(2)} €",
                        foreground: cs.tertiary,
                        background: cs.tertiaryContainer.withOpacity(.25),
                      ),
                      _MetricChip.elevated(
                        context,
                        label: "Margin",
                        value: "${summary.marginPercent.toStringAsFixed(1)}%",
                        foreground: cs.secondary,
                        background: cs.secondaryContainer.withOpacity(.25),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Material 3–style chip that shows "Label: Value" with subtle tonal background.
class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color foreground;
  final Color background;

  const _MetricChip._({
    required this.label,
    required this.value,
    required this.foreground,
    required this.background,
  });

  factory _MetricChip.elevated(
    BuildContext context, {
    required String label,
    required String value,
    required Color foreground,
    required Color background,
  }) {
    return _MetricChip._(
      label: label,
      value: value,
      foreground: foreground,
      background: background,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
      backgroundColor: background,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: text.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: value,
              style: text.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
