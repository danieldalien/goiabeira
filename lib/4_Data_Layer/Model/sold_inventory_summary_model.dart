import 'dart:io';

class SoldInventorySummaryModel {
  final String id;
  final String title;
  final int totalQuantitySold;
  final double totalProfit;
  final DateTime lastSoldDate;
  final File? imageFile;
  final String? imageUrl;

  SoldInventorySummaryModel({
    required this.id,
    required this.title,
    required this.totalQuantitySold,
    required this.totalProfit,
    required this.lastSoldDate,
    this.imageFile,
    this.imageUrl,
  });

  SoldInventorySummaryModel copyWith({
    String? id,
    String? title,
    int? totalQuantitySold,
    double? totalProfit,
    DateTime? lastSoldDate,
    File? imageFile,
    String? imageUrl,
  }) => SoldInventorySummaryModel(
    id: id ?? this.id,
    title: title ?? this.title,
    totalQuantitySold: totalQuantitySold ?? this.totalQuantitySold,
    totalProfit: totalProfit ?? this.totalProfit,
    lastSoldDate: lastSoldDate ?? this.lastSoldDate,
    imageFile: imageFile ?? this.imageFile,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}
