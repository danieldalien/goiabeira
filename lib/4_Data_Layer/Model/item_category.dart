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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconData': iconData?.codePoint,
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

  factory ItemCategory.fromString(String name) {
    return ItemCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: '',
      iconData: null,
    );
  }

  ItemCategory.empty() : id = '', name = '', description = '', iconData = null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemCategory &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.iconData == iconData;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      (iconData?.hashCode ?? 0);
}
