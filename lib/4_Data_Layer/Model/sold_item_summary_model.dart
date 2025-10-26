import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';

class SoldItemSummaryModel {
  final int soldQuantity;
  final SoldItem soldItem;
  final double totalRevenue;
  final double totalProfit;
  final double marginPercent; // per-unit (current price)
  final TimeWindow timeWindow;

  SoldItemSummaryModel({
    required this.soldItem,
    required this.soldQuantity,
    required this.totalRevenue,
    required this.totalProfit,
    required this.marginPercent,
    required this.timeWindow,
  });
}
