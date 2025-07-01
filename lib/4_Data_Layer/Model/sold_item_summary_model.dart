import 'package:goiabeira/0_Core/Enums/date_granularity.dart';

class SoldItemSummaryModel {
  final int soldQuantity;
  final int id;
  final double totalRevenue;
  final double totalProfit;
  final DateGranularity timeGranularity;

  SoldItemSummaryModel({
    required this.id,
    required this.soldQuantity,
    required this.totalRevenue,
    required this.totalProfit,
    required this.timeGranularity,
  });
}
