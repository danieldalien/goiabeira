import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:goiabeira/0_Core/Enums/enum_item_category.dart';
import 'package:goiabeira/0_Core/Utility/number_manipulation.dart';

class StockItem {
  final String title;
  final String description;
  final double buyPrice;
  final double sellPrice;
  final StockItemCategoryEnum category;
  final List<String> imageList;
  final int id;
  final String idSupplier;
  final String barcodeArticel;
  final String barcodeSupplier;
  final int quantity;
  List<File?> imageFiles = [];

  StockItem({
    required this.title,
    required this.description,
    required this.buyPrice,
    required this.sellPrice,
    required this.category,
    required this.imageList,
    required this.id,
    required this.idSupplier,
    required this.barcodeArticel,
    required this.barcodeSupplier,
    required this.quantity,
    this.imageFiles = const [],
  });

  // Named constructor with initializing formals
  StockItem.createStockItem({
    required this.title,
    required this.description,
    required this.buyPrice,
    required this.sellPrice,
    required this.category,
    required this.imageList,
    required this.id,
    required this.idSupplier,
    required this.barcodeArticel,
    required this.barcodeSupplier,
    required this.quantity,
    this.imageFiles = const [],
  });

  StockItem.empty()
    : title = '',
      description = '',
      buyPrice = 0.0,
      sellPrice = 0.0,
      category = StockItemCategoryEnum.none,
      imageList = [],
      id = DateTime.now().millisecondsSinceEpoch,
      idSupplier = '',
      barcodeArticel = '',
      barcodeSupplier = '',
      quantity = 0,
      imageFiles = [];

  StockItem.test()
    : title = 'Test',
      description = 'Test',
      buyPrice = 0.0,
      sellPrice = 0.0,
      category = StockItemCategoryEnum.none,
      imageList = [],
      id = DateTime.now().millisecondsSinceEpoch,
      idSupplier = 'Test',
      barcodeArticel = 'Test',
      barcodeSupplier = 'Test',
      quantity = 0,
      imageFiles = [];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'category': category.name,
      'imageList': imageList.isEmpty ? [''] : jsonEncode(imageList),
      'id': id,
      'idSupplier': idSupplier,
      'barcodeArticel': barcodeArticel,
      'barcodeSupplier': barcodeSupplier,
      'quantity': quantity,
    };
  }

  static Map<String, dynamic> toMap(StockItem stockItem) {
    return {
      'title': stockItem.title,
      'description': stockItem.description,
      'buyPrice': stockItem.buyPrice,
      'sellPrice': stockItem.sellPrice,
      'category': stockItem.category.name,
      'imageList':
          stockItem.imageList.isEmpty ? [''] : jsonEncode(stockItem.imageList),
      'id': stockItem.id,
      'idSupplier': stockItem.idSupplier,
      'barcodeArticel': stockItem.barcodeArticel,
      'barcodeSupplier': stockItem.barcodeSupplier,
      'quantity': stockItem.quantity,
    };
  }

  factory StockItem.fromJson(Map<String, dynamic> json) {
    // Processing imageList to remove extra single quotes from URLs
    List<String> cleanedImageList = [];
    if (json['imageList'].runtimeType == String) {
      cleanedImageList =
          (jsonDecode(json['imageList']) as List<dynamic>).map<String>((item) {
            if (item is String) {
              return item;
            } else if (item is List<int>) {
              // Force a cast to List<int> and convert to String.
              return String.fromCharCodes(item.cast<int>());
            }
            throw Exception(
              'Unexpected type in imageList: ${item.runtimeType}',
            );
          }).toList();
    }

    // Ensuring buyPrice is treated as double
    double buyPrice = 0.0;

    if (json['buyPrice'] != null) {
      buyPrice =
          json['buyPrice'].runtimeType == int
              ? (json['buyPrice'] as int).toDouble()
              : json['buyPrice'];
    }
    // Ensuring sellPrice is treated as double
    double sellPrice = 0.0;
    if (json['sellPrice'] != null) {
      sellPrice =
          json['sellPrice'].runtimeType == int
              ? (json['sellPrice'] as int).toDouble()
              : json['sellPrice'];
    }
    return StockItem(
      title: json['title'],
      description: json['description'],
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      category: stringToStockItemCategoryEnum(json['category']),
      imageList: cleanedImageList, // Use the cleaned image list
      id: NumberManipulation.numberToInt(json['id']) ?? 0,
      idSupplier: json['idSupplier'],
      barcodeArticel: json['barcodeArticel'],
      barcodeSupplier: json['barcodeSupplier'],
      quantity: json['quantity'],
    );
  }

  StockItem copyWith({
    String? title,
    String? description,
    double? buyPrice,
    double? sellPrice,
    StockItemCategoryEnum? category,
    List<String>? imageList,
    int? id,
    String? idSupplier,
    String? barcodeArticel,
    String? barcodeSupplier,
    int? quantity,
    List<File?>? imageFiles,
  }) {
    return StockItem(
      title: title ?? this.title,
      description: description ?? this.description,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      category: category ?? this.category,
      imageList: imageList ?? this.imageList,
      id: id ?? this.id,
      idSupplier: idSupplier ?? this.idSupplier,
      barcodeArticel: barcodeArticel ?? this.barcodeArticel,
      barcodeSupplier: barcodeSupplier ?? this.barcodeSupplier,
      quantity: quantity ?? this.quantity,
      imageFiles: imageFiles ?? this.imageFiles,
    );
  }

  static StockItemCategoryEnum stringToStockItemCategoryEnum(
    String inputString,
  ) {
    for (StockItemCategoryEnum value in StockItemCategoryEnum.values) {
      if (value.toString().split('.').last == inputString) {
        return value;
      }
    }
    return StockItemCategoryEnum.none; // or return a default value
  }
}
