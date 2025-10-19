import 'dart:async';

import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/0_Core/Utility/date_time_utility.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';
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
  /// Calculates the total stock value.
  /// If [timeWindow] is given, includes only items bought within that period.
  @override
  double getTotalStockValue({TimeWindow? timeWindow}) {
    DateTime? start;
    DateTime? end;

    final range = timeWindow?.getRange();
    if (range != null) {
      start = range.$1;
      end = range.$2;
    }

    final filtered = stockItems.where((item) {
      if (start == null || end == null) return true;
      return !item.createdAt.isBefore(start) && !item.createdAt.isAfter(end);
    });

    return filtered.fold<double>(
      0.0,
      (total, item) => total + item.buyPrice * item.quantity,
    );
  }

  /// Calculates the total sold value (revenue) within a timeframe.
  /// Accepts either [start]/[end] or a [timeWindow].
  @override
  double getTotalSoldValue({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  }) {
    // Resolve timeframe
    DateTime? s = start;
    DateTime? e = end;

    final range = timeWindow?.getRange();
    if ((s == null || e == null) && range != null) {
      s = range.$1;
      e = range.$2;
    }

    // Filter items if a range is provided
    final filtered = soldItems.where((item) {
      if (s == null || e == null) return true; // all-time
      return !item.sellDate.isBefore(s) && !item.sellDate.isAfter(e);
    });

    // Sum up the total sold value
    return filtered.fold<double>(
      0.0,
      (total, item) => total + item.sellPrice * item.quantitySold,
    );
  }

  /// Returns overall profit as (sellPrice - buyPrice) * quantitySold
  /// within a timeframe. If no timeframe is provided → all-time.
  ///
  /// Profit is attributed to the period of the SALE (sellDate),
  /// regardless of when the stock was bought.
  @override
  double getTotalProfit({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  }) {
    // Resolve timeframe from TimeWindow if needed
    DateTime? s = start;
    DateTime? e = end;

    final range = timeWindow?.getRange(); // from the TimeWindowRange extension
    if ((s == null || e == null) && range != null) {
      s = range.$1;
      e = range.$2;
    }

    final Iterable<SoldItem> filtered = soldItems.where((item) {
      if (s == null || e == null) return true; // all-time
      return !item.sellDate.isBefore(s) && !item.sellDate.isAfter(e);
    });

    return filtered.fold<double>(
      0.0,
      (total, item) =>
          total +
          (item.sellPrice - item.stockItem.buyPrice) * item.quantitySold,
    );
  }

  /// Calculates profit for sold items filtered by [category].
  /// Accepts either explicit [start]/[end] or a [timeWindow].
  @override
  double getProfitByCategory(
    String category, {
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  }) {
    DateTime? s = start;
    DateTime? e = end;

    final range = timeWindow?.getRange();
    if ((s == null || e == null) && range != null) {
      s = range.$1;
      e = range.$2;
    }

    final filtered = soldItems.where((item) {
      final matchesCategory = item.stockItem.category.name == category;
      if (!matchesCategory) return false;
      if (s == null || e == null) return true;
      return !item.sellDate.isBefore(s) && !item.sellDate.isAfter(e);
    });

    return filtered.fold<double>(
      0.0,
      (total, item) => total + item.sellPrice * item.quantitySold,
    );
  }

  /// Returns the total quantity of sold items within a timeframe.
  /// If no timeframe is provided, returns all-time total.
  @override
  int getTotalSoldQuantity({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  }) {
    DateTime? s = start;
    DateTime? e = end;

    final range = timeWindow?.getRange();
    if ((s == null || e == null) && range != null) {
      s = range.$1;
      e = range.$2;
    }

    final filtered = soldItems.where((item) {
      if (s == null || e == null) return true;
      return !item.sellDate.isBefore(s) && !item.sellDate.isAfter(e);
    });

    return filtered.fold<int>(0, (total, item) => total + item.quantitySold);
  }

  /// Returns the total quantity of stock items within a timeframe.
  /// If [timeWindow] is provided, filters by [buyDate].
  @override
  int getTotalStockQuantity({
    DateTime? start,
    DateTime? end,
    TimeWindow? timeWindow,
  }) {
    DateTime? s = start;
    DateTime? e = end;

    final range = timeWindow?.getRange();
    if ((s == null || e == null) && range != null) {
      s = range.$1;
      e = range.$2;
    }

    final filtered = stockItems.where((item) {
      if (s == null || e == null) return true;
      return !item.createdAt.isBefore(s) && !item.createdAt.isAfter(e);
    });

    return filtered.fold<int>(0, (total, item) => total + item.quantity);
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
  AnalyzeModel getAnalyzeModelForTimeWindow(TimeWindow timeWindow) {
    // Implementation depends on how AnalyzeModel is defined.
    // Here we return a dummy model for demonstration.
    final AnalyzeModel analyzeModel = AnalyzeModel(
      totalStockValue: getTotalStockValue(timeWindow: timeWindow),
      totalSoldValue: getTotalSoldValue(timeWindow: timeWindow),
      totalProfit: getTotalProfit(timeWindow: timeWindow),
      totalSoldQuantity: getTotalSoldQuantity(timeWindow: timeWindow),
      totalStockQuantity: getTotalStockQuantity(timeWindow: timeWindow),
    );

    return analyzeModel;
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

  double getStockValueByTimeWindow(TimeWindow timeWindow) {
    // Implementation depends on how you define stock value by time window.
    // Here we return a dummy value for demonstration.
    return getTotalStockValue();
  }
}
