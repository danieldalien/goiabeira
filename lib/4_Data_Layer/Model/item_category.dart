import 'package:flutter/widgets.dart';

class ItemCategory {
  final String id;
  final String name;
  final String description;
  final IconData? iconData;

  ItemCategory({
    required this.id,
    required this.name,
    required this.description,
    this.iconData,
  });

  static Map<String, dynamic> toMap(ItemCategory itemCategory) {
    return {
      'id': itemCategory.id,
      'name': itemCategory.name,
      'description': itemCategory.description,
      'iconData': itemCategory.iconData?.codePoint,
    };
  }

  factory ItemCategory.fromJson(Map<String, dynamic> map) {
    return ItemCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconData:
          map['iconData'] != null
              ? IconData(map['iconData'], fontFamily: 'MaterialIcons')
              : null,
    );
  }
}
