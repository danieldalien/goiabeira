import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/stock_item_formular.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/height_spacer.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class StockItemFormularScreen extends StatelessWidget {
  final StockItem? stockItem;
  final Function(BuildContext, StockItem) onSubmitted;
  final Function(BuildContext, StockItem) onDelete;
  const StockItemFormularScreen({
    required this.onSubmitted,
    required this.onDelete,
    this.stockItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeightSpacer(multiplier: 5),
          StockItemFormular(
            stockItem: stockItem,
            onSubmitted: (stockItem) => onSubmitted(context, stockItem),
            onDelete: (stockItem) => onDelete(context, stockItem),
          ),
        ],
      ),
    );
  }
}
