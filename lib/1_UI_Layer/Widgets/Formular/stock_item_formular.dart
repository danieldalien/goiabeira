import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/client_model.dart';
import 'package:goiabeira/0_Core/Enums/enum_item_category.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/image_picker_widget.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/title_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/description_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/price_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/quantity_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/id_supplier_input.dart';

class StockItemFormular extends StatefulWidget {
  const StockItemFormular({
    super.key,
    this.stockItem,
    required this.onSubmitted,
    required this.onDelete,
  });

  final StockItem? stockItem;
  final ValueChanged<StockItem> onSubmitted;
  final ValueChanged<StockItem> onDelete;

  @override
  State<StockItemFormular> createState() => _StockItemFormularState();
}

class _StockItemFormularState extends State<StockItemFormular> {
  /* ─────────────────────────── controllers ─────────────────────────── */
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  final _buyC = TextEditingController();
  final _sellC = TextEditingController();
  final _qtyC = TextEditingController();
  final _supplierC = TextEditingController();

  /* ─────────────────────────── state ─────────────────────────── */
  StockItemCategoryEnum _category = StockItemCategoryEnum.none;
  final List<File> _imageFiles = [];
  final List<String> _imageList = [];

  late StockItem _initial; // safe-default for copyWith

  @override
  void initState() {
    super.initState();
    if (widget.stockItem != null) {
      final s = widget.stockItem!;
      _titleC.text = s.title;
      _descC.text = s.description;
      _buyC.text = s.buyPrice.toString();
      _sellC.text = s.sellPrice.toString();
      _qtyC.text = s.quantity.toString();
      _supplierC.text = s.idSupplier;
      _category = s.category;
      _imageList.addAll(s.imageList);
      _imageFiles.addAll(s.imageFiles.cast<File>());
      _initial = s;
    } else {
      _initial = StockItem.empty();
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _buyC.dispose();
    _sellC.dispose();
    _qtyC.dispose();
    _supplierC.dispose();
    super.dispose();
  }

  /* ─────────────────────────── UI ─────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 0, // flat per M3
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(),
                const SizedBox(height: 24),

                /* ── fields ── */
                TitleInput(
                  onChanged: (v) => _titleC.text = v,
                  initialValue: _titleC.text,
                ),
                const SizedBox(height: 16),
                DescriptionInput(
                  onChanged: (v) => _descC.text = v,
                  initialValue: _descC.text,
                ),
                const SizedBox(height: 16),
                PriceInput(
                  labelText: 'Buy price',
                  onChanged: (v) => _buyC.text = v,
                  initialValue: _buyC.text,
                ),
                const SizedBox(height: 16),
                PriceInput(
                  labelText: 'Sell price',
                  onChanged: (v) => _sellC.text = v,
                  initialValue: _sellC.text,
                ),
                const SizedBox(height: 16),
                QuantityInput(
                  onChanged: (v) => _qtyC.text = v,
                  initialValue: _qtyC.text,
                ),
                const SizedBox(height: 16),
                SupplierIdInput(
                  onChanged: (v) => _supplierC.text = v,
                  initialValue: _supplierC.text,
                ),
                const SizedBox(height: 24),

                _ImagePickerCard(
                  imageFiles: _imageFiles,
                  onImagesSelected: (files) {
                    setState(() {
                      _imageFiles
                        ..clear()
                        ..addAll(files);
                    });
                  },
                ),
                const SizedBox(height: 24),

                _ActionButtons(
                  isNew: widget.stockItem == null,
                  onSave: _save,
                  onDelete: _delete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ─────────────────────────── handlers ─────────────────────────── */
  void _save() {
    try {
      final item = _initial.copyWith(
        title: _titleC.text,
        description: _descC.text,
        buyPrice: double.parse(_buyC.text),
        sellPrice: double.parse(_sellC.text),
        category: _category,
        imageList: _imageList,
        idSupplier: _supplierC.text,
        quantity: int.parse(_qtyC.text),
        imageFiles: _imageFiles,
      );
      widget.onSubmitted(item);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check your input values.')),
      );
    }
  }

  void _delete() {
    if (widget.stockItem != null) widget.onDelete(widget.stockItem!);
  }
}

/* ───────────────────────── sections ───────────────────────── */

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.inventory, color: scheme.primary),
      title: const Text(
        'Stock item',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({
    required this.imageFiles,
    required this.onImagesSelected,
  });

  final List<File> imageFiles;
  final ValueChanged<List<File>> onImagesSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 250,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: scheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ImagePickerWidget(
        onImagesSelected: onImagesSelected,
        selectedImages: imageFiles,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.isNew,
    required this.onSave,
    required this.onDelete,
  });

  final bool isNew;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (!isNew)
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: onDelete,
          ),
        ),
      if (!isNew) const SizedBox(width: 16),
      Expanded(
        child: FilledButton.icon(
          icon: const Icon(Icons.save),
          label: Text(isNew ? 'Save' : 'Update'),
          onPressed: onSave,
        ),
      ),
    ];

    return Row(children: children);
  }
}
