import 'dart:convert';

import 'package:goiabeira/0_Core/Utility/number_manipulation.dart';
import 'package:goiabeira/4_Data_Layer/Model/client_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class SoldItem {
  final int idSoldItem;
  final StockItem stockItem;
  final double sellPrice;
  final int quantitySold;
  final DateTime sellDate;
  final ClientModel client;
  double discount;

  SoldItem({
    int? idSoldItem,
    required this.stockItem,
    required this.sellPrice,
    required this.quantitySold,
    required this.client,
    DateTime? sellDate,
    this.discount = 0.0,
  }) : idSoldItem = idSoldItem ?? DateTime.now().millisecondsSinceEpoch,
       sellDate = sellDate ?? DateTime.now();

  double get profit {
    return sellPrice - stockItem.buyPrice;
  }

  int get quantity => stockItem.quantity;

  // Named constructor with initializing formals
  Map<String, dynamic> toJson() {
    return {
      'idSoldItem': idSoldItem,
      'stockItem': stockItem.toJson(),
      'sellPrice': sellPrice,
      'quantitySold': quantitySold,
      'sellDate': sellDate.toString(), // '2021-10-10 10:10:10.000
      'clientName': client.toJson(),
      'discount': discount,
    };
  }

  // Named constructor with initializing formals
  static Map<String, dynamic> toMap(SoldItem soldItem) {
    return {
      'id': soldItem.stockItem.id,
      'title': soldItem.stockItem.title,
      'description': soldItem.stockItem.description,
      'buyPrice': soldItem.stockItem.buyPrice,
      'sellPrice': soldItem.stockItem.sellPrice,
      'idSoldItem': soldItem.idSoldItem,
      'category': soldItem.stockItem.category.name,
      'imageList':
          soldItem.stockItem.imageList.isEmpty
              ? ['']
              : jsonEncode(soldItem.stockItem.imageList),
      'idSupplier': soldItem.stockItem.idSupplier,
      'barcodeArticel': soldItem.stockItem.barcodeArticel,
      'barcodeSupplier': soldItem.stockItem.barcodeSupplier,
      'quantity': soldItem.stockItem.quantity,
      'quantitySold': soldItem.quantitySold,
      'sellPriceReal': soldItem.sellPrice,
      'sellDate': soldItem.sellDate.toString(), // '2021-10-10 10:10:10.000
      'customerId': soldItem.client.id,
    };
  }

  factory SoldItem.fromJson(Map<String, dynamic> json) {
    // Explicitly cast the 'stockItem' map to 'Map<String, dynamic>'
    // This ensures the map is correctly typed before passing to 'StockItem.fromJson'

    // Ensuring buyPrice is treated as double
    double discount =
        NumberManipulation.numberToDouble(json['discount']) ?? 0.0;

    double sellPrice =
        NumberManipulation.numberToDouble(json['sellPrice']) ?? 0.0;

    double sellPriceReal =
        NumberManipulation.numberToDouble(json['sellPriceReal']) ?? 0.0;

    int quantitySold =
        NumberManipulation.numberToInt(json['quantitySold']) ?? 0;

    return SoldItem(
      idSoldItem: int.parse(json['idSoldItem']),
      stockItem: StockItem.fromJson(json),
      sellPrice: sellPriceReal,
      quantitySold: quantitySold,
      sellDate: DateTime.parse(json['sellDate']),
      client: json['clientName'] ?? ClientModel.empty(),
      discount: discount,
    );
  }

  SoldItem copyWith({
    int? idSoldItem,
    StockItem? stockItem,
    double? sellPrice,
    int? quantitySold,
    DateTime? sellDate,
    ClientModel? client,
    double? discount,
  }) {
    return SoldItem(
      idSoldItem: idSoldItem ?? this.idSoldItem,
      stockItem: stockItem ?? this.stockItem,
      sellPrice: sellPrice ?? this.sellPrice,
      quantitySold: quantitySold ?? this.quantitySold,
      sellDate: sellDate ?? this.sellDate,
      client: client ?? this.client,
      discount: discount ?? this.discount,
    );
  }
}
