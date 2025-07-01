import 'package:flutter/material.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class StockItemService {
  static Widget buildImageWidget(StockItem stockItem) {
    // Determine which image to display: local file, network image, or placeholder.
    if (stockItem.imageFiles.isNotEmpty && stockItem.imageFiles.first != null) {
      return Image.file(
        stockItem.imageFiles.first!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else if (stockItem.imageList.isNotEmpty &&
        stockItem.imageList.first.isNotEmpty) {
      return Image.network(
        stockItem.imageList.first,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 80, color: Colors.grey),
      );
    }
  }
}
