import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/quantiy_value_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';

abstract class AnalyticsService {
  final SellHandlerInterface sellHandlerInterface;
  final StockHandlerInterface stockHandlerInterface;

  AnalyticsService({
    required this.sellHandlerInterface,
    required this.stockHandlerInterface,
  });

  Future<void> init() async {}
  Future<void> dispose() async {}

  double getTotalStockValue({TimeWindow? timeWindow});

  double getTotalSoldValue({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  });

  double getTotalProfit({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  });

  //int getSoldQuantityByTimeframe(DateTime start, DateTime end);

  double getProfitByCategory(
    String category, {
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  });

  int getTotalSoldQuantity({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  });

  int getTotalStockQuantity({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  });

  Map<ItemCategory, QuantiyValueModel> getQuantityValueByCategory();

  List<SoldItemSummaryModel> getTopSellers({
    required TimeWindow timeWindow,

    int limit = 10,
    //SortBy sortBy = SortBy.quantity, // quantity | revenue | profit
  });
  AnalyzeModel getAnalyzeModelForTimeWindow(TimeWindow timeWindow);
}
