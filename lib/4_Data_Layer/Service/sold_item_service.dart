import 'package:goiabeira/0_Core/Enums/date_granularity.dart';
import 'package:goiabeira/0_Core/Enums/enum_item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';

class SoldItemService {
  final List<SoldItem> soldItems;
  SoldItemService({required this.soldItems});

  List<SoldItemSummaryModel> _dailySoldItemsSummary = [];
  List<SoldItemSummaryModel> _weeklySoldItemsSummary = [];
  List<SoldItemSummaryModel> _monthlySoldItemsSummary = [];
  List<SoldItemSummaryModel> _yearlySoldItemsSummary = [];

  void updateSoldItems(List<SoldItem> newSoldItems) {
    soldItems.clear();
    soldItems.addAll(newSoldItems);
  }

  List<SoldItemSummaryModel> getSoldItemsSummary({
    required DateGranularity timeGranularity,
    required int id,
  }) {
    switch (timeGranularity) {
      case DateGranularity.day:
        return getDailySoldItemsSummary(id);
      case DateGranularity.week:
        return getWeeklySoldItemsSummary();
      case DateGranularity.month:
        return getMonthlySoldItemsSummary();
      case DateGranularity.year:
        return getYearlySoldItemsSummary();
      default:
        throw Exception('Unsupported time granularity: $timeGranularity');
    }
  }

  List<SoldItemSummaryModel> getDailySoldItemsSummary(int id) {
    List<SoldItem> filtered =
        soldItems.where((si) => si.stockItem.id == id).toList();
    // Implement logic to get daily sold items summary
    List<SoldItemSummaryModel> dailySummary = [];
    double totalRevenue = 0.0;
    double totalProfit = 0.0;
    int soldQuantity = 0;
    DateTime lastDate = DateTime.now();
    for (int i = 0; i < soldItems.length; i++) {
      SoldItem item = soldItems[i];

      if (i == 0) {
        lastDate = item.sellDate;
        totalRevenue = item.sellPrice * item.quantitySold;
        totalProfit = item.profit * item.quantitySold;
        soldQuantity = item.quantitySold;
      } else if (item.sellDate.day == lastDate.day &&
          item.sellDate.month == lastDate.month &&
          item.sellDate.year == lastDate.year) {
        totalRevenue += item.sellPrice * item.quantitySold;
        totalProfit += item.profit * item.quantitySold;
        soldQuantity += item.quantitySold;
      } else {
        dailySummary.add(
          SoldItemSummaryModel(
            id: item.stockItem.id,
            soldQuantity: soldQuantity,
            totalRevenue: totalRevenue,
            totalProfit: totalProfit,
            timeGranularity: DateGranularity.day,
          ),
        );
        // Reset for the next day
        lastDate = item.sellDate;
        totalRevenue = item.sellPrice * item.quantitySold;
        totalProfit = item.profit * item.quantitySold;
        soldQuantity = item.quantitySold;
      }

      // Logic to aggregate daily summary

      // Example: dailySummary.add(SoldItemSummaryModel(...));
    }
    return [];
  }

  List<SoldItemSummaryModel> getWeeklySoldItemsSummary() {
    // Implement logic to get weekly sold items summary
    return [];
  }

  List<SoldItemSummaryModel> getMonthlySoldItemsSummary() {
    // Implement logic to get monthly sold items summary
    return [];
  }

  List<SoldItemSummaryModel> getYearlySoldItemsSummary() {
    // Implement logic to get yearly sold items summary
    return [];
  }

  List<SoldItem> getSoldItemsById(int id) {
    return soldItems.where((item) => item.stockItem.id == id).toList();
  }

  List<SoldItem> getSoldItemsByDate(DateTime date) {
    return soldItems
        .where(
          (item) =>
              item.sellDate.day == date.day &&
              item.sellDate.month == date.month &&
              item.sellDate.year == date.year,
        )
        .toList();
  }

  List<SoldItem> getSoldItemsByDateRange(DateTime start, DateTime end) {
    return soldItems.where((item) {
      return item.sellDate.isAfter(start) && item.sellDate.isBefore(end);
    }).toList();
  }

  List<SoldItem> getSoldItemsByCategory(StockItemCategoryEnum category) {
    return soldItems
        .where((item) => item.stockItem.category == category)
        .toList();
  }

  List<double> getProfitForItem(int id) {
    return soldItems
        .where((item) => item.stockItem.id == id)
        .map((item) => item.profit * item.quantitySold)
        .toList();
  }

  List<double> getRevenueForItem(int id) {
    return soldItems
        .where((item) => item.stockItem.id == id)
        .map((item) => item.sellPrice * item.quantitySold)
        .toList();
  }

  List<double> getQuantityForItem(int id) {
    return soldItems
        .where((item) => item.stockItem.id == id)
        .map((item) => item.quantitySold.toDouble())
        .toList();
  }

  List<SoldInventorySummaryModel> getInventorySummaryByItem() {
    final Map<int, SoldInventorySummaryModel> summaryMap = {};

    for (final item in soldItems) {
      final key = item.stockItem.id;
      print(key);

      if (summaryMap.containsKey(key)) {
        final existing = summaryMap[key]!;

        summaryMap[key] = existing.copyWith(
          totalQuantitySold: existing.totalQuantitySold + item.quantitySold,
          totalProfit: existing.totalProfit + item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
        );
      } else {
        summaryMap[key] = SoldInventorySummaryModel(
          id: key.toString(),
          title: item.stockItem.title,
          totalQuantitySold: item.quantitySold,
          totalProfit: item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
          imageFile:
              item.stockItem.imageFiles.isNotEmpty
                  ? item.stockItem.imageFiles.first
                  : null,

          imageUrl:
              item.stockItem.imageList.isNotEmpty
                  ? item.stockItem.imageList.first
                  : null,
        );
      }
    }

    return summaryMap.values.toList();
  }

  List<SoldInventorySummaryModel> getInventorySummaryByDate() {
    final Map<String, SoldInventorySummaryModel> summaryMap = {};

    for (final item in soldItems) {
      final key =
          '${item.sellDate.year}-${item.sellDate.month}-${item.sellDate.day}';

      if (summaryMap.containsKey(key)) {
        final existing = summaryMap[key]!;

        summaryMap[key] = existing.copyWith(
          totalQuantitySold: existing.totalQuantitySold + item.quantitySold,
          totalProfit: existing.totalProfit + item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
        );
      } else {
        summaryMap[key] = SoldInventorySummaryModel(
          id: key,
          title: 'Sales on ${item.sellDate.toLocal()}',
          totalQuantitySold: item.quantitySold,
          totalProfit: item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
          imageFile: null,
          imageUrl: null,
        );
      }
    }

    return summaryMap.values.toList();
  }

  List<SoldInventorySummaryModel> getInventorySummaryByCategory() {
    final Map<StockItemCategoryEnum, SoldInventorySummaryModel> summaryMap = {};

    for (final item in soldItems) {
      final key = item.stockItem.category;

      if (summaryMap.containsKey(key)) {
        final existing = summaryMap[key]!;

        summaryMap[key] = existing.copyWith(
          totalQuantitySold: existing.totalQuantitySold + item.quantitySold,
          totalProfit: existing.totalProfit + item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
        );
      } else {
        summaryMap[key] = SoldInventorySummaryModel(
          id: key.toString(),
          title: key.name,
          totalQuantitySold: item.quantitySold,
          totalProfit: item.profit * item.quantitySold,
          lastSoldDate: item.sellDate,
          imageFile: null,
          imageUrl: null,
        );
      }
    }

    return summaryMap.values.toList();
  }
}
