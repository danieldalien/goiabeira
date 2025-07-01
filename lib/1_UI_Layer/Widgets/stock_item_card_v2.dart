import 'package:flutter/material.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/gradient_overlay.dart';

import 'package:goiabeira/1_UI_Layer/Widgets/Service/stock_item_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class StockItemCardV2 extends StatelessWidget {
  const StockItemCardV2({
    super.key,
    required this.stockItem,
    required this.onSell,
    required this.onEdit,
  });

  final StockItem stockItem;
  final VoidCallback onSell;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      surfaceTintColor: scheme.surfaceTint,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onEdit,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                StockItemService.buildImageWidget(stockItem),
                const GradientOverlay(), // extracted widget
              ],
            ),
          ),
        ),
        title: Text(stockItem.title),
        subtitle: Text('Qty ${stockItem.quantity} • ${stockItem.sellPrice} €'),
        trailing: FilledButton.tonalIcon(
          onPressed: onSell,
          icon: const Icon(Icons.sell),
          label: const Text('Sell'),
        ),
      ),
    );
  }
}
