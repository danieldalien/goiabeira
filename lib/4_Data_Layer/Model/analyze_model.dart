import 'package:equatable/equatable.dart';

class AnalyzeModel extends Equatable {
  /// Total value of stock (buyPrice * quantity)
  final double totalStockValue;

  /// Total sold value (sellPrice * quantitySold)
  final double totalSoldValue;

  /// Overall profit (total sold value - total stock value)
  final double totalProfit;

  final int totalSoldQuantity;

  final int totalStockQuantity;

  const AnalyzeModel({
    required this.totalStockValue,
    required this.totalSoldValue,
    required this.totalProfit,
    required this.totalSoldQuantity,
    required this.totalStockQuantity,
  });

  @override
  List<Object?> get props => [
    totalStockValue,
    totalSoldValue,
    totalProfit,
    totalSoldQuantity,
    totalStockQuantity,
  ];

  const AnalyzeModel.empty()
    : totalStockValue = 0,
      totalSoldValue = 0,
      totalProfit = 0,
      totalSoldQuantity = 0,
      totalStockQuantity = 0;

  /// Optionally, you can add a copyWith method if you plan on updating parts of the model.
  AnalyzeModel copyWith({
    double? totalStockValue,
    double? totalSoldValue,
    double? totalProfit,
    int? totalSoldQuantity,
    int? totalStockQuantity,
  }) {
    return AnalyzeModel(
      totalStockValue: totalStockValue ?? this.totalStockValue,
      totalSoldValue: totalSoldValue ?? this.totalSoldValue,
      totalProfit: totalProfit ?? this.totalProfit,
      totalSoldQuantity: totalSoldQuantity ?? this.totalSoldQuantity,
      totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
    );
  }
}
