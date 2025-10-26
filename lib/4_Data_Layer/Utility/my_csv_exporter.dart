import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/widgets.dart'
    show Rect; // for iPad popover origin (optional)

import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class MyCsvExporter {
  final String subfolder; // '' => directly in Documents
  final bool includeUtf8Bom; // Excel-friendly
  final String fieldDelimiter; // default ','
  final String eol; // default '\r\n'

  MyCsvExporter({
    String? subfolder,
    bool? includeUtf8Bom,
    String? fieldDelimiter,
    String? eol,
  }) : subfolder = subfolder ?? '',
       includeUtf8Bom = includeUtf8Bom ?? true,
       fieldDelimiter = fieldDelimiter ?? ',',
       eol = eol ?? '\r\n';

  /// Export StockItems, share immediately. Returns saved path.
  Future<String> exportStockItemsToCsv(
    List<StockItem> stockItems, {
    Rect? sharePositionOrigin, // useful on iPad
  }) async {
    final maps = stockItems.map((e) => StockItem.toCsv(e)).toList();
    return _exportMapsAsCsv(
      maps: maps,
      baseName: 'stock_items',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Export SoldItems, share immediately. Returns saved path.
  Future<String> exportSoldItemsToCsv(
    List<SoldItem> soldItems, {
    Rect? sharePositionOrigin,
  }) async {
    final maps = soldItems.map((e) => SoldItem.toCsv(e)).toList();
    return _exportMapsAsCsv(
      maps: maps,
      baseName: 'sold_items',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Core export: writes CSV to Documents (optionally into [subfolder]),
  /// prints result, verifies file, and opens the share sheet.
  Future<String> _exportMapsAsCsv({
    required List<Map<String, dynamic>> maps,
    required String baseName,
    bool includeHeaders = true,
    Rect? sharePositionOrigin,
  }) async {
    if (maps.isEmpty) {
      throw StateError('No data to export for "$baseName".');
    }

    // 1) headers + rows
    final headers = maps.first.keys.toList();
    final rows = <List<dynamic>>[];
    if (includeHeaders) rows.add(headers);
    for (final m in maps) {
      rows.add(headers.map((h) => m[h]).toList());
    }

    // 2) CSV string
    final converter = ListToCsvConverter(
      fieldDelimiter: fieldDelimiter,
      eol: eol,
    );
    final csvString = converter.convert(rows);

    // 3) Target directory = Documents[/subfolder]
    final docsDir = await getApplicationDocumentsDirectory();
    Directory targetDir = docsDir;
    if (subfolder.isNotEmpty) {
      targetDir = Directory(p.join(docsDir.path, subfolder));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
    }

    // 4) File path
    final timestamp = _safeTimestamp(DateTime.now()); // yyyy-MM-dd_HH-mm-ss
    final filePath = p.join(targetDir.path, '${baseName}_$timestamp.csv');
    final file = File(filePath);

    // 5) Write
    if (includeUtf8Bom) {
      final bytes = <int>[0xEF, 0xBB, 0xBF]..addAll(utf8.encode(csvString));
      await file.writeAsBytes(bytes, flush: true);
    } else {
      await file.writeAsString(csvString, flush: true);
    }

    // 6) Verify
    final exists = await file.exists();
    final length = exists ? await file.length() : 0;

    if (exists && length > 0) {
      print("✅ CSV export successful!");
      print("📂 Saved in Documents at: $filePath");
      print("📏 File size: $length bytes");

      // 7) Share sheet
      // Note: On iPad, pass a proper [sharePositionOrigin] rect from the calling widget.
      // Example from a button handler:
      // final box = context.findRenderObject() as RenderBox;
      // final origin = box.localToGlobal(Offset.zero) & box.size;
      // exporter.exportStockItemsToCsv(items, sharePositionOrigin: origin);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(filePath, mimeType: 'text/csv', name: p.basename(filePath)),
          ],
          text: 'Exported $baseName CSV',
          subject: 'Exported $baseName',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } else {
      print("❌ CSV export failed: file missing or empty at $filePath");
    }

    return file.path;
  }

  String _safeTimestamp(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
