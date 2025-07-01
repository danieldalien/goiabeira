import 'package:goiabeira/0_Core/Utility/date_time_utility.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class AnalyticsServiceImpl implements AnalyticsService {
  late final List<StockItem> stockItems;
  late final List<SoldItem> soldItems;
  bool _isInitialized = false;

  @override
  final SellHandlerInterface sellHandlerInterface;
  @override
  final StockHandlerInterface stockHandlerInterface;

  AnalyticsServiceImpl({
    required this.sellHandlerInterface,
    required this.stockHandlerInterface,
  });

  /// Initializes the service by reading all stock and sold items.
  @override
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    stockItems = await stockHandlerInterface.readAllStockItems();
    soldItems = await sellHandlerInterface.readAllSoldItems();
    _isInitialized = true;
  }

  /// Returns the total value of stock (buyPrice * quantity) for all items.
  @override
  double getTotalStockValue() {
    return stockItems.fold(
      0.0,
      (double total, item) => total + item.buyPrice * item.quantity,
    );
  }

  /// Returns the total sold value (sellPrice * quantitySold) for all sold items.
  @override
  double getTotalSoldValue() {
    return soldItems.fold(
      0.0,
      (double total, item) => total + item.sellPrice * item.quantitySold,
    );
  }

  /// Returns the overall profit as total sold value minus total stock value.
  @override
  double getTotalProfit() {
    double profit = 0.0;
    for (SoldItem item in soldItems) {
      profit += (item.sellPrice - item.stockItem.buyPrice) * item.quantitySold;
    }
    return profit;
  }

  /// Calculates profit for sold items whose sellDate is between [start] and [end].
  @override
  double getProfitByTimeframe(DateTime start, DateTime end) {
    return soldItems
        .where(
          (item) =>
              !item.sellDate.isBefore(start) && !item.sellDate.isAfter(end),
        )
        .fold(
          0.0,
          (double total, item) => total + item.sellPrice * item.quantitySold,
        );
  }

  @override
  double getProfitForThisWeek() {
    final DateTime firstDayOfWeek = DateTimeUtility.getFirstDayOfWeek();
    return getProfitByTimeframe(firstDayOfWeek, DateTime.now());
  }

  @override
  double getProfitForThisMonth() {
    final DateTime firstDayOfMonth = DateTimeUtility.getFirstDayOfMonth();
    return getProfitByTimeframe(firstDayOfMonth, DateTime.now());
  }

  /// Groups profits by period from [start] to now in intervals of [days] days.
  @override
  Map<DateTime, double> getProfitByPeriod(DateTime start, int days) {
    final profits = <DateTime, double>{};
    final now = DateTime.now();
    final int totalDays = now.difference(start).inDays;

    for (int i = 0; i < totalDays; i += days) {
      final DateTime periodStart = start.add(Duration(days: i));
      DateTime periodEnd = periodStart.add(Duration(days: days));
      // Clamp periodEnd to now if it goes beyond.
      if (periodEnd.isAfter(now)) {
        periodEnd = now;
      }
      double profit = getProfitByTimeframe(periodStart, periodEnd);
      profits[periodStart] = profit;
    }
    return profits;
  }

  /// Calculates profit for sold items filtered by [category].
  @override
  double getProfitByCategory(String category) {
    return soldItems
        .where((item) => item.stockItem.category.name == category)
        .fold(
          0.0,
          (double total, item) => total + item.sellPrice * item.quantitySold,
        );
  }

  /// Returns the total quantity of sold items.
  @override
  int getTotalSoldQuantity() {
    return soldItems.fold(0, (int total, item) => total + item.quantitySold);
  }

  /// Returns the total quantity of stock items.
  @override
  int getTotalStockQuantity() {
    return stockItems.fold(0, (int total, item) => total + item.quantity);
  }
}
