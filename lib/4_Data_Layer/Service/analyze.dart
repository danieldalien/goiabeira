import 'package:goiabeira/0_Core/Enums/date_interval_enum.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class DataAnalyser {
  final List<StockItem> stockItemList;
  final List<SoldItem> soldItemList;

  DataAnalyser({required this.stockItemList, required this.soldItemList});

  double get totalValueInStock {
    double totalValueInStock = 0;
    for (var item in stockItemList) {
      totalValueInStock += item.quantity * item.buyPrice;
    }
    return double.parse(totalValueInStock.toStringAsFixed(2));
  }

  int get totalItemsInStock {
    int totalItemsInStock = 0;
    for (var item in stockItemList) {
      totalItemsInStock += item.quantity;
    }
    return totalItemsInStock;
  }

  double get totalValueSold {
    double totalValueSold = 0;
    for (var item in soldItemList) {
      totalValueSold += item.sellPrice;
    }
    return double.parse(totalValueSold.toStringAsFixed(2));
  }

  int get totalItemsSold {
    return soldItemList.length;
  }

  double get totalProfit {
    double totalProfit = 0;
    for (var item in soldItemList) {
      totalProfit += (item.sellPrice - item.stockItem.buyPrice);
    }
    return double.parse(totalProfit.toStringAsFixed(2));
  }

  Map<DateTime, int> soldItemQuantityListByTimePeriod({
    DateIntervalEnum timePeriod = DateIntervalEnum.day,
  }) {
    Map<DateTime, int> countMap = {};

    for (SoldItem item in soldItemList) {
      DateTime date;
      switch (timePeriod) {
        case DateIntervalEnum.day:
          date = DateTime(
            item.sellDate.year,
            item.sellDate.month,
            item.sellDate.day,
          );
          break;
        case DateIntervalEnum.month:
          date = DateTime(item.sellDate.year, item.sellDate.month);
          break;
        case DateIntervalEnum.year:
          date = DateTime(item.sellDate.year);
          break;
        default:
          date = DateTime(
            item.sellDate.year,
            item.sellDate.month,
            item.sellDate.day,
          );
      }

      if (!countMap.containsKey(date)) {
        countMap[date] = 1;
      } else {
        countMap[date] = countMap[date]! + 1;
      }
    }

    return countMap;
  }

  Map<DateTime, double> profitListByTimePeriod({
    DateIntervalEnum timePeriod = DateIntervalEnum.day,
  }) {
    Map<DateTime, double> profitMap = {};

    for (SoldItem item in soldItemList) {
      DateTime date;
      switch (timePeriod) {
        case DateIntervalEnum.day:
          date = DateTime(
            item.sellDate.year,
            item.sellDate.month,
            item.sellDate.day,
          );
          break;
        case DateIntervalEnum.month:
          date = DateTime(item.sellDate.year, item.sellDate.month);
          break;
        case DateIntervalEnum.year:
          date = DateTime(item.sellDate.year);
          break;
        default:
          date = DateTime(
            item.sellDate.year,
            item.sellDate.month,
            item.sellDate.day,
          );
      }

      if (!profitMap.containsKey(date)) {
        profitMap[date] = item.profit;
      } else {
        profitMap[date] = profitMap[date]! + item.profit;
      }
    }

    return profitMap;
  }

  Map<DateTime, double> fillDatesWithZeros(Map<DateTime, num> dates) {
    if (dates.isEmpty) {
      return {};
    }

    // Find the earliest and latest date
    DateTime earliestDate = dates.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime latestDate = dates.keys.reduce((a, b) => a.isAfter(b) ? a : b);

    // Initialize the result map
    Map<DateTime, double> filledDates = {};

    // Iterate from the earliest date to the latest date
    for (
      DateTime date = earliestDate;
      date.isBefore(latestDate.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      // Format the date as a string

      // Add the date with its value or 0 if it doesn't exist in the original map
      filledDates[date] = dates[date]?.toDouble() ?? 0.0;
    }

    return filledDates;
  }
}
