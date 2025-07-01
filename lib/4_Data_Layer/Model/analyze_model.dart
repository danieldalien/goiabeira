import 'package:equatable/equatable.dart';

class AnalyzeModel extends Equatable {
  /// Total value of stock (buyPrice * quantity)
  final double totalStockValue;

  /// Total sold value (sellPrice * quantitySold)
  final double totalSoldValue;

  /// Overall profit (total sold value - total stock value)
  final double totalProfit;

  /// A mapping of period start dates to profit values computed for that period.
  final Map<DateTime, double> profitByPeriod;

  final int totalSoldQuantity;

  final int totalStockQuantity;

  /// Profit made in the current week
  final double profitThisWeek;

  /// Profit made in the current month
  final double profitThisMonth;

  const AnalyzeModel({
    required this.totalStockValue,
    required this.totalSoldValue,
    required this.totalProfit,
    required this.profitByPeriod,
    required this.totalSoldQuantity,
    required this.totalStockQuantity,
    required this.profitThisWeek,
    required this.profitThisMonth,
  });

  @override
  List<Object?> get props => [
    totalStockValue,
    totalSoldValue,
    totalProfit,
    profitByPeriod,
    totalSoldQuantity,
    totalStockQuantity,
    profitThisWeek,
    profitThisMonth,
  ];

  AnalyzeModel.empty()
    : totalStockValue = 0,
      totalSoldValue = 0,
      totalProfit = 0,
      profitByPeriod = {},
      totalSoldQuantity = 0,
      totalStockQuantity = 0,
      profitThisWeek = 0,
      profitThisMonth = 0;

  /// Optionally, you can add a copyWith method if you plan on updating parts of the model.
  AnalyzeModel copyWith({
    double? totalStockValue,
    double? totalSoldValue,
    double? totalProfit,
    Map<DateTime, double>? profitByPeriod,
    int? totalSoldQuantity,
    int? totalStockQuantity,
    double? profitThisWeek,
    double? profitThisMonth,
  }) {
    return AnalyzeModel(
      totalStockValue: totalStockValue ?? this.totalStockValue,
      totalSoldValue: totalSoldValue ?? this.totalSoldValue,
      totalProfit: totalProfit ?? this.totalProfit,
      profitByPeriod: profitByPeriod ?? this.profitByPeriod,
      totalSoldQuantity: totalSoldQuantity ?? this.totalSoldQuantity,
      totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
      profitThisWeek: profitThisWeek ?? this.profitThisWeek,
      profitThisMonth: profitThisMonth ?? this.profitThisMonth,
    );
  }
}
