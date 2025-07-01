import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/icon_text_button.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Service/stock_item_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class StockItemCard extends StatelessWidget {
  final StockItem stockItem;
  final VoidCallback onSell;
  final VoidCallback onEdit;

  const StockItemCard({
    super.key,
    required this.stockItem,
    required this.onSell,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which image to display: local file, network image, or placeholder.
    Widget imageWidget = StockItemService.buildImageWidget(stockItem);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with gradient overlay for a warm effect.
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                imageWidget,
                Positioned.fill(child: Container(decoration: BoxDecoration())),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title styled with warm brown color.
                Text(
                  stockItem.title,
                  style: AppTextStyle.cardHeader.copyWith(
                    color: Colors.brown[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Description with a subtle grey tone.
                Text(
                  stockItem.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardBody.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                // Price and Quantity in a neatly spaced row.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: \$${stockItem.sellPrice.toStringAsFixed(2)}",
                      style: AppTextStyle.cardBody.copyWith(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /*
                    QuantitySelector(
                      quantity: 2,
                      onChanged: _onQuantityChanged,
                    ),
                    */
                    Text(
                      "Qty: ${stockItem.quantity}",
                      style: AppTextStyle.cardBody.copyWith(
                        color:
                            stockItem.quantity == 0
                                ? AppColors.errorRed
                                : Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Action buttons for editing and selling the item.
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Outlined "Edit" button using a warm deep orange accent.
        Container(
          child: IconTextButton(
            onTap: onEdit,
            icon: Icons.edit,
            text: "Edit     ",
            backgroundColor: AppColors.editButtonBackground,
            textStyle: AppTextStyle.buttonTextStyle.copyWith(
              color: AppColors.editButtonText,
            ),
            border: true,
            borderColor: Colors.deepOrange,
            iconColor: Colors.deepOrange,
            padding: 8,
          ),
        ),
        const SizedBox(width: 12),
        // Elevated "Sell" button with a warm background.
        IconTextButton(
          onTap: onSell,
          icon: Icons.sell,
          text: "Sell     ",
          backgroundColor: AppColors.sellButtonBackground,
          textStyle: AppTextStyle.buttonTextStyle.copyWith(
            color: AppColors.sellButtonText,
          ),
          border: true,
          borderColor: Colors.deepOrange,
          iconColor: Colors.deepOrange,
          padding: 8,
        ),
      ],
    );
  }

  void _onQuantityChanged(int newQuantity) {
    // Handle quantity change logic here
    // For example, update the state or notify the parent widget
    print('New quantity: $newQuantity');
  }
}
