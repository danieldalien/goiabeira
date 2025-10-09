import 'dart:async';

import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/0_Core/Utility/date_time_utility.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/quantiy_value_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class AnalyticsServiceImpl implements AnalyticsService {
  late List<StockItem> stockItems;
  late List<SoldItem> soldItems;
  late final StreamSubscription<List<StockItem>> _stockSubscription;
  late final StreamSubscription<List<SoldItem>> _soldSubscription;
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
    // Listen to stock item changes to keep data up-to-date.
    _stockSubscription = stockHandlerInterface.stockItemStream.listen((items) {
      stockItems = items;
    });

    // Listen to sold item changes to keep data up-to-date.
    _soldSubscription = sellHandlerInterface.soldItemStream.listen((items) {
      soldItems = items;
      print('soldItems updated: ${soldItems.length} items');
    });
  }

  @override
  Future<void> dispose() async {
    await _stockSubscription.cancel();
    await _soldSubscription.cancel();
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

  /// Returns a map of ItemCategory to QuantiyValueModel with total quantity and value.
  /// Value is calculated as buyPrice * quantity.
  @override
  Map<ItemCategory, QuantiyValueModel> getQuantityValueByCategory() {
    final Map<ItemCategory, QuantiyValueModel> result = {};
    for (var item in soldItems) {
      if (result.containsKey(item.stockItem.category)) {
        result[item.stockItem.category]!.quantity += item.quantitySold;
        result[item.stockItem.category]!.value +=
            item.sellPrice * item.quantitySold;
      } else {
        result[item.stockItem.category] = QuantiyValueModel(
          quantity: item.quantitySold,
          value: item.sellPrice * item.quantity,
        );
      }
    }
    return result;
  }

  @override
  List<SoldItemSummaryModel> getTopSellers({
    required TimeWindow timeWindow,
    int limit = 10,
  }) {
    DateTime start;
    DateTime end = DateTime.now();

    switch (timeWindow) {
      case TimeWindow.today:
        start = DateTime(end.year, end.month, end.day);
        break;
      case TimeWindow.thisWeek:
        start = DateTimeUtility.getFirstDayOfWeek();
        break;
      case TimeWindow.last7Days:
        start = end.subtract(Duration(days: 7));
        break;
      case TimeWindow.last30Days:
        start = end.subtract(Duration(days: 30));
        break;
      case TimeWindow.thisMonth:
        start = DateTime(end.year, end.month, 1);
        break;
      case TimeWindow.thisYear:
        start = DateTime(end.year, 1, 1);
        break;
      case TimeWindow.allTime:
        start = DateTime(2000); // Arbitrary early date
        break;
      case TimeWindow.custom:
        // For custom, you might want to pass start and end as parameters.
        // Here we default to the last 30 days for demonstration.
        start = end.subtract(Duration(days: 30));
        break;
    }

    // Filter sold items within the specified timeframe
    final filteredItems = soldItems.where(
      (item) => !item.sellDate.isBefore(start) && !item.sellDate.isAfter(end),
    );

    // Aggregate data by StockItem ID
    final Map<int, SoldItemSummaryModel> summaryMap = {};

    for (SoldItem item in filteredItems) {
      if (summaryMap.containsKey(item.stockItem.id)) {
        final SoldItemSummaryModel existing = summaryMap[item.stockItem.id]!;
        summaryMap[item.stockItem.id] = SoldItemSummaryModel(
          soldItem: item,
          soldQuantity: existing.soldQuantity + item.quantitySold,
          totalRevenue:
              existing.totalRevenue + (item.sellPrice * item.quantitySold),
          totalProfit:
              existing.totalProfit +
              ((item.sellPrice - item.stockItem.buyPrice) * item.quantitySold),
          marginPercent:
              existing.totalRevenue != 0
                  ? ((existing.totalProfit +
                              (item.sellPrice - item.stockItem.buyPrice) *
                                  item.quantitySold) /
                          (existing.totalRevenue +
                              (item.sellPrice * item.quantitySold))) *
                      100
                  : 0.0,
          timeWindow: timeWindow,
        );
      } else {
        summaryMap[item.stockItem.id] = SoldItemSummaryModel(
          soldItem: item,
          soldQuantity: item.quantitySold,
          totalRevenue: item.sellPrice * item.quantitySold,
          totalProfit:
              (item.sellPrice - item.stockItem.buyPrice) * item.quantitySold,
          marginPercent:
              item.sellPrice != 0
                  ? ((item.sellPrice - item.stockItem.buyPrice) /
                          item.sellPrice) *
                      100
                  : 0.0,
          timeWindow: timeWindow,
        );
      }
    }

    // Convert to list and sort by totalQuantitySold descending
    final sortedSummaries =
        summaryMap.values.toList()
          ..sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));

    // Return top [limit] sellers
    return sortedSummaries.take(limit).toList();
  }
}
