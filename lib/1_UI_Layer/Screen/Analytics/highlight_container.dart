import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/time_window_popup_menu.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/top_selling_item_card.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';

class HighlightContainer extends StatelessWidget {
  const HighlightContainer({
    required this.selectedTimeWindow,
    required this.timeWindowsItems,
    required this.topSellers,
    required this.onSelected,
    this.title = 'Best Sellers',
    this.maxItems, // optional: cap the visible items
    super.key,
  });

  final TimeWindow selectedTimeWindow;
  final List<TimeWindow> timeWindowsItems;
  final List<SoldItemSummaryModel> topSellers;
  final ValueChanged<TimeWindow> onSelected;
  final String title;
  final int? maxItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Decide how many items to show (optional cap)
    final items =
        (maxItems == null) ? topSellers : topSellers.take(maxItems!).toList();

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest, // M3-friendly surface
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ---- Header ------------------------------------------------------
            ListTile(
              dense: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: scheme.secondaryContainer,
                child: Icon(
                  Icons.trending_up,
                  color: scheme.onSecondaryContainer,
                ),
              ),
              title: Text(title, style: theme.textTheme.titleLarge),
              subtitle: Text(
                selectedTimeWindow.displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              trailing: TimeWindowPopupMenu(
                label: selectedTimeWindow.displayName,
                color: scheme.secondary,
                items: timeWindowsItems,
                onSelected: onSelected,
              ),
            ),

            const SizedBox(height: 8),
            Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
            const SizedBox(height: 8),

            // ---- Body --------------------------------------------------------
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Builder(
                builder: (context) {
                  if (items.isEmpty) {
                    return _EmptyState(scheme: scheme);
                  }

                  // Responsive: grid on wider layouts, list on narrow
                  final width = MediaQuery.of(context).size.width;
                  final useGrid = width >= 680; // tweak threshold to taste

                  if (useGrid) {
                    // Non-scrollable grid inside Card
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio:
                                3.0, // tune for your card dimensions
                          ),
                      itemBuilder: (context, index) {
                        final summary = items[index];
                        return TopSellingItemCard(
                          summary: summary,
                          onTap: () {},
                        );
                      },
                    );
                  } else {
                    // Non-scrollable list inside Card
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final summary = items[index];
                        return TopSellingItemCard(
                          summary: summary,
                          onTap: () {},
                        );
                      },
                    );
                  }
                },
              ),
            ),

            if (maxItems != null && topSellers.length > (maxItems ?? 0)) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    // navigate to a full list page, or lift state to show all
                  },
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('See all'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.insights_outlined, size: 32, color: scheme.outline),
          const SizedBox(height: 8),
          Text(
            'No data for this period',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
