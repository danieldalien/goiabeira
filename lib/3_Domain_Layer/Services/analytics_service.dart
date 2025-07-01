import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';

abstract class AnalyticsService {
  final SellHandlerInterface sellHandlerInterface;
  final StockHandlerInterface stockHandlerInterface;

  AnalyticsService({
    required this.sellHandlerInterface,
    required this.stockHandlerInterface,
  });

  Future<void> init() async {}

  double getTotalStockValue();
  double getTotalSoldValue();

  double getTotalProfit();

  double getProfitByTimeframe(DateTime start, DateTime end);

  double getProfitForThisWeek();
  double getProfitForThisMonth();

  Map<DateTime, double> getProfitByPeriod(DateTime start, int days);

  //int getSoldQuantityByTimeframe(DateTime start, DateTime end);

  double getProfitByCategory(String category);

  int getTotalSoldQuantity();
  int getTotalStockQuantity();
}
