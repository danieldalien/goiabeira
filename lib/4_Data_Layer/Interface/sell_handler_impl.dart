import 'dart:io';

import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/file_storage_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Service/sold_item_service.dart';

class SellHandlerImpl implements SellHandlerInterface {
  List<SoldItem> _soldItems = [];
  late final SoldItemService _soldItemService;
  @override
  final DatabaseRepository<SoldItem> repository;
  @override
  final FileStorageRepo fileStorageRepository;

  SellHandlerImpl({
    required this.repository,
    required this.fileStorageRepository,
  });

  @override
  Future<void> init(dynamic db) async {
    _soldItems = await readAllSoldItems();
    _soldItemService = SoldItemService(soldItems: _soldItems);
  }

  @override
  Future<void> createSoldItem(SoldItem soldItem) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed

    try {
      print(
        '3 SELL HANDLER. Selling item: ${soldItem.stockItem.title} : with Stock_ID ${soldItem.stockItem.id} , SELL_ID: ${soldItem.idSoldItem}',
      );
      await repository.create(soldItem);
      _soldItems.add(soldItem);
      // Update the service with the new sold item
      _soldItemService.updateSoldItems(_soldItems);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> updateSoldItem(SoldItem soldItem, String id) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed

    try {
      _soldItems.removeWhere((element) => element.idSoldItem == int.parse(id));
      _soldItems.add(soldItem);
      // Update the service with the modified sold item
      _soldItemService.updateSoldItems(_soldItems);
      await repository.update(id, soldItem);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> deleteSoldItem(SoldItem soldItem) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed
    try {
      _soldItems.removeWhere(
        (element) => element.idSoldItem == soldItem.idSoldItem,
      );
      // Update the service with the modified sold items list
      _soldItemService.updateSoldItems(_soldItems);
      await repository.delete(soldItem.idSoldItem.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<SoldItem?> readSoldItem(String id) async {
    try {
      return await repository.read(id);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<List<SoldItem>> readAllSoldItems() async {
    if (_soldItems.isNotEmpty) {
      return _soldItems;
    }
    try {
      _soldItems = await repository.readAll();
      final List<Future> futures = [];
      for (SoldItem soldItem in _soldItems) {
        futures.add(downloadImages(soldItem.stockItem.imageList));
      }
      final List files = await Future.wait(futures);
      for (int i = 0; i < _soldItems.length; i++) {
        _soldItems[i] = _soldItems[i].copyWith(
          stockItem: _soldItems[i].stockItem.copyWith(imageFiles: files[i]),
        );
      }
      return _soldItems;
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  List<SoldInventorySummaryModel> getInventorySummaryByItem() {
    return _soldItemService.getInventorySummaryByItem();
  }

  @override
  List<SoldInventorySummaryModel> getInventorySummaryByDate() {
    return _soldItemService.getInventorySummaryByDate();
  }

  @override
  List<SoldInventorySummaryModel> getInventorySummaryByCategory() {
    return _soldItemService.getInventorySummaryByCategory();
  }

  /* Helper methods */

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
}
