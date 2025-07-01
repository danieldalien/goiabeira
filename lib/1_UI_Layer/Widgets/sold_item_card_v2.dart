import 'dart:io';
import 'package:flutter/material.dart';

import 'package:goiabeira/1_UI_Layer/Widgets/General/gradient_overlay.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/image_widget.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';

/// A tappable card that shows last-sale info for a stock item.
///
/// * [id] payload returned in [onTap].
/// * Uses the app’s `ColorScheme` & typography tokens — so dark-mode
///   and dynamic-colour work automatically.
class SoldBaseInventoryCard extends StatelessWidget {
  final SoldInventorySummaryModel summaryModel;
  final ValueChanged<String> onTap;

  const SoldBaseInventoryCard({
    super.key,
    required this.summaryModel,
    required this.onTap,
  });

  /* ────────────────────── build ────────────────────── */
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      surfaceTintColor: scheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // ripple inside rounded card
        onTap: () => onTap(summaryModel.id),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: _Thumbnail(
            imageFile: summaryModel.imageFile,
            imageUrl: summaryModel.imageUrl,
          ),
          title: Text(summaryModel.title, style: textTheme.titleSmall),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Sold: ${summaryModel.totalQuantitySold} • Profit: ${summaryModel.totalProfit}',
                style: textTheme.bodySmall,
              ),
              Text(
                'Last sold: ${summaryModel.lastSoldDate}',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

/* ──────────────────── helpers ──────────────────── */

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({this.imageFile, this.imageUrl});

  final File? imageFile;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageWidget(
              // your existing helper
              imageFile: imageFile,
              imageUrl: imageUrl,
              width: double.infinity,
            ),
            const GradientOverlay(), // subtle darken for readability
          ],
        ),
      ),
    );
  }
}
