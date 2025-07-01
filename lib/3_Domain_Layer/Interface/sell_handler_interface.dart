import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';

abstract class SellHandlerInterface {
  final DatabaseRepository<SoldItem> repository;
  final FileStorageRepo fileStorageRepository;

  SellHandlerInterface({
    required this.repository,
    required this.fileStorageRepository,
  });

  Future<void> init(dynamic initDatabase);

  Future<void> createSoldItem(SoldItem soldItem);

  Future<void> updateSoldItem(SoldItem soldItem, String id);

  Future<void> deleteSoldItem(SoldItem soldItem);

  Future<SoldItem?> readSoldItem(String id);

  Future<List<SoldItem>> readAllSoldItems();

  List<SoldInventorySummaryModel> getInventorySummaryByItem();

  List<SoldInventorySummaryModel> getInventorySummaryByDate();

  List<SoldInventorySummaryModel> getInventorySummaryByCategory();
}
