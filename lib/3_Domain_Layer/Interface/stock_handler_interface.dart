import 'dart:io';

import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

abstract class StockHandlerInterface {
  final DatabaseRepository<StockItem> repository;
  final FileStorageRepo fileStorageRepository;

  StockHandlerInterface({
    required this.repository,
    required this.fileStorageRepository,
  });
  Future<List<StockItem>> stockItems();

  Future<void> init(dynamic initDatabase);

  Future<List<String>> uploadImages(List<File> images);

  Future<List<File>> downloadImages(List<String> imageUrl);

  Future<void> createStockItem(StockItem stockItem);

  Future<List<StockItem>> readAllStockItems();

  Future<void> updateStockItem(StockItem stockItem, String id);

  Future<void> deleteStockItem(StockItem stockItem);

  Future<StockItem?> readStockItem(String id);

  Future<void> sellStockItem(StockItem stockItem, int quantity);
}
