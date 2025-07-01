import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/icon_text_button.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Service/stock_item_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';

class SoldItemCard extends StatelessWidget {
  final SoldItem soldItem;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewDetails;

  const SoldItemCard({
    required this.soldItem,
    this.onEdit,
    this.onDelete,
    this.onViewDetails,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildItemCard(soldItem);
  }

  Widget _buildItemCard(SoldItem item) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Image section
          Expanded(child: StockItemService.buildImageWidget(item.stockItem)),
          // Essential details section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(item.stockItem.title),
                  const SizedBox(height: 8),
                  // Description (truncated)
                  Text(
                    item.stockItem.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("SellPrice: \$${item.sellPrice.toStringAsFixed(2)}"),
                      Text("Qty: ${item.quantitySold}"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date of sale
                  Text(
                    "Last Sold on: ${item.sellDate.toLocal().toString().split(' ')[0]}",
                    style: AppTextStyle.cardBody.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Action buttons for editing and selling the item.
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        IconTextButton(
          icon: Icons.edit,
          text: 'Edit  ',
          backgroundColor: AppColors.generalButtonBackground,
          textStyle: AppTextStyle.defaultText,
          onTap: onEdit,
        ),
        const SizedBox(width: 8),

        IconTextButton(
          icon: Icons.delete,
          text: 'Delete  ',
          backgroundColor: AppColors.errorRed,
          textStyle: AppTextStyle.defaultText,
          onTap: onDelete,
        ),
      ],
    );
  }
}
