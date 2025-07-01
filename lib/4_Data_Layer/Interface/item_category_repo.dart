import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goiabeira/3_Domain_Layer/Repo/database_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';

class ItemCategoryRepo {
  List<ItemCategory> _itemCategories = [];

  final DatabaseRepository<ItemCategory> repository;

  ItemCategoryRepo({required this.repository});

  Future<void> init() async {
    _itemCategories = await getItemCategories();
  }

  Future<List<ItemCategory>> getItemCategories() async {
    if (_itemCategories.isNotEmpty) {
      return _itemCategories;
    }

    _itemCategories = await repository.readAll();

    if (_itemCategories.isEmpty) {
      _itemCategories = _getDefaultItemCategories();
      List<Future<void>> createTasks = [];
      for (ItemCategory itemCategory in _itemCategories) {
        createTasks.add(repository.create(itemCategory));
      }
      await Future.wait(createTasks);
      return _itemCategories;
    }
    return _itemCategories;
  }

  List<ItemCategory> _getDefaultItemCategories() {
    return [
      ItemCategory(
        name: 'Services',
        id: '1',
        description: 'Services and utilities',
        iconData: Icons.sell_rounded,
      ),
      ItemCategory(
        id: '2',
        name: 'Rings',
        description: 'Rings and jewelry',
        iconData: Icons.ring_volume_rounded,
      ),
      ItemCategory(
        id: '3',
        name: 'Necklaces',
        description: 'Necklaces and pendants',
        iconData: Icons.near_me_rounded,
      ),
      ItemCategory(
        id: '4',
        name: 'Bracelets',
        description: 'Bracelets and bangles',
        iconData: Icons.brush_rounded,
      ),
      ItemCategory(
        id: '5',
        name: 'Spirituality',
        description: 'Spiritual and religious items',
        iconData: Icons.safety_check,
      ),
    ];
  }

  Future<void> createItemCategory(ItemCategory itemCategory) async {
    await repository.create(itemCategory);
    _itemCategories.add(itemCategory);
  }

  Future<void> updateItemCategory(ItemCategory itemCategory, String id) async {
    _itemCategories.removeWhere((element) => element.id == id);
    _itemCategories.add(itemCategory);
    await repository.update(id, itemCategory);
  }

  Future<void> deleteItemCategory(ItemCategory itemCategory) async {
    _itemCategories.removeWhere((element) => element.id == itemCategory.id);
    await repository.delete(itemCategory.id);
  }
}
