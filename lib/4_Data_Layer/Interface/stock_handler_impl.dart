import 'dart:io';

import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class StockHandlerImpl implements StockHandlerInterface {
  List<StockItem> _stockItems = [];

  @override
  final DatabaseRepository<StockItem> repository;
  @override
  final FileStorageRepo fileStorageRepository;

  /*
  static const stockItemTable = {
    'stock_items_table': '''
    CREATE TABLE stock_items_table (
      id TEXT PRIMARY KEY,
      title TEXT,
      description TEXT,
      buyPrice REAL,
      category TEXT,
      imageList TEXT,
      idSupplier TEXT,
      barcodeArticel TEXT,
      barcodeSupplier TEXT,
      quantity INTEGER
    )
  '''
  };
  */
  StockHandlerImpl({
    required this.repository,
    required this.fileStorageRepository,
  });

  @override
  Future<List<StockItem>> stockItems() async {
    if (_stockItems.isEmpty) {
      _stockItems = await readAllStockItems();
    }
    return _stockItems;
  }

  @override
  Future<void> init(dynamic db) async {
    await stockItems();
  }

  @override
  Future<void> createStockItem(StockItem stockItem) async {
    print(stockItem.runtimeType); // Ensure values match expected types
    print(stockItem); // View the exact data being passed
    print('Creating stock item: ${stockItem.title} with ID: ${stockItem.id}');
    List<String> imageUrls = await fileStorageRepository.createMultipleFiles(
      stockItem.imageFiles,
    );
    try {
      await repository.create(stockItem.copyWith(imageList: imageUrls));
      _stockItems.add(stockItem);
    } catch (e) {
      throw Exception('Failed to create stock item');
    }
  }

  @override
  Future<List<String>> uploadImages(List<File> images) async {
    final List<String> imagesStrings = await fileStorageRepository
        .createMultipleFiles(images);
    return imagesStrings;
  }

  @override
  Future<List<File>> downloadImages(List<String> imageUrl) async {
    final List<File> images = [];
    List<Future> futures = [];
    for (var url in imageUrl) {
      futures.add(fileStorageRepository.readFile(url));
    }
    List files = await Future.wait(futures);

    for (var image in files) {
      if (image != null) {
        images.add(image);
      }
    }
    return images;
  }

  @override
  Future<StockItem?> readStockItem(String id) async {
    final StockItem? stockItem = await repository.read(id);
    if (stockItem == null) {
      return null;
    }
    final List<File> images = await downloadImages(stockItem.imageList);
    return stockItem.copyWith(imageFiles: images);
  }

  @override
  Future<void> updateStockItem(StockItem stockItem, String id) async {
    await repository.update(id, stockItem);
  }

  @override
  Future<void> deleteStockItem(StockItem stockItem) async {
    await repository.delete(stockItem.id.toString());
    await fileStorageRepository.deleteFiles(stockItem.imageList);
    _stockItems.remove(stockItem);
  }

  @override
  Future<List<StockItem>> readAllStockItems() async {
    if (_stockItems.isNotEmpty) {
      return _stockItems;
    }
    final stockItems = await repository.readAll();
    final List<Future> futures = [];
    for (var stockItem in stockItems) {
      futures.add(downloadImages(stockItem.imageList));
    }
    final List images = await Future.wait(futures);
    for (var i = 0; i < stockItems.length; i++) {
      stockItems[i] = stockItems[i].copyWith(imageFiles: images[i]);
      print(
        'Stock item loaded: ${stockItems[i].title}, ID: ${stockItems[i].id}',
      );
    }
    return stockItems;
  }

  @override
  Future<void> sellStockItem(StockItem stockItem, int quantity) async {
    await repository.update(
      stockItem.id.toString(),
      stockItem.copyWith(quantity: stockItem.quantity - quantity),
    );

    print('Stock item sold: , quantity: $quantity');
  }
}
