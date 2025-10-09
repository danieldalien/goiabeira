import 'dart:async';
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

  final _soldItemBroadcast = StreamController<List<SoldItem>>.broadcast();

  @override
  Stream<List<SoldItem>> get soldItemStream => _soldItemBroadcast.stream;

  void _emit() {
    // Snapshot details
    final len = _soldItems.length;
    final ids = _soldItems.map((e) => e.id).toList();
    print(
      '[SellHandler] EMIT len=$len ids=$ids  listRef=${_soldItems.hashCode}',
    );
    _soldItemBroadcast.add(List.unmodifiable(_soldItems));
  }

  @override
  Future<void> init(dynamic db) async {
    _soldItems = await readAllSoldItems();
    _soldItemService = SoldItemService(soldItems: List.of(_soldItems));
    _emit();
  }

  @override
  Future<void> createSoldItem(SoldItem soldItem) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed

    try {
      print(
        '3 SELL HANDLER. Selling item: ${soldItem.stockItem.title} : with Stock_ID ${soldItem.stockItem.id} , SELL_ID: ${soldItem.id}',
      );
      await repository.create(soldItem);
      _soldItems.add(soldItem);
      // Update the service with the new sold item
      _soldItemService.updateSoldItems(List.of(_soldItems));
      _emit();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> updateSoldItem(SoldItem soldItem, String id) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed

    try {
      _soldItems.removeWhere((element) => element.id == int.parse(id));
      _soldItems.add(soldItem);
      // Update the service with the modified sold item
      _soldItemService.updateSoldItems(List.of(_soldItems));
      await repository.update(id, soldItem);
      _emit();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> deleteSoldItem(SoldItem soldItem) async {
    print(soldItem.runtimeType); // Ensure values match expected types
    print(soldItem); // View the exact data being passed
    try {
      _soldItems.removeWhere((element) => element.id == soldItem.id);
      // Update the service with the modified sold items list
      _soldItemService.updateSoldItems(List.of(_soldItems));
      await repository.delete(soldItem.id.toString());
      _emit();
    } catch (e) {
      throw Exception('Failed to delete sold item');
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
    return _soldItems;
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
