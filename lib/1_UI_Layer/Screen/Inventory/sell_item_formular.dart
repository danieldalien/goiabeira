import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goiabeira/4_Data_Layer/Model/client_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class SellItemFormular extends StatefulWidget {
  final StockItem stockItem;
  final SoldItem? soldItem;
  final ValueChanged<SoldItem> onSubmitted;

  const SellItemFormular({
    super.key,
    required this.stockItem,
    required this.onSubmitted,
    this.soldItem,
  });

  @override
  State<SellItemFormular> createState() => _SellItemFormularState();
}

class _SellItemFormularState extends State<SellItemFormular> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _priceCtrl;

  // ――― helpers ―――
  static const SizedBox _gap16 = SizedBox(height: 16);
  static const SizedBox _gap24 = SizedBox(height: 24);

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(
      text: '${widget.soldItem?.quantitySold ?? 1}',
    );
    _priceCtrl = TextEditingController(
      text: widget.stockItem.sellPrice.toString(),
    );
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sell ${widget.stockItem.title}', style: textTheme.titleLarge),
            _gap24,

            // ── Quantity ──
            _NumberField(
              controller: _qtyCtrl,
              label: 'Quantity',
              icon: Icons.numbers,
              validator: (v) {
                if (v == null) return 'Enter a quantity';
                v = v.trim();
                if (v.isEmpty) return 'Enter a quantity';
                // Check if the quantity is a valid integer greater than 0
                return (int.tryParse(v) ?? 0) <= 0
                    ? 'Enter a valid quantity'
                    : null;
              },
            ),
            _gap16,

            // ── Price ──
            _NumberField(
              controller: _priceCtrl,
              label: 'Price (€)',
              icon: Icons.euro,
              validator: (v) {
                if (v == null) return 'Enter a price';
                v = v.trim();
                if (v.isEmpty) return 'Enter a price';
                // Check if the price is a valid double
                final price = double.tryParse(v.replaceAll(',', '.'));
                return price == null || price <= 0
                    ? 'Enter a valid price'
                    : null;
              },
            ),
            _gap24,

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.sell),
                label: const Text('Sell'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ────────────────────────── helpers ────────────────────────── */

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final qty = int.parse(_qtyCtrl.text);
    final price = double.parse(_priceCtrl.text.replaceAll(',', '.'));

    final sale =
        widget.soldItem?.copyWith(quantitySold: qty, sellPrice: price) ??
        SoldItem(
          stockItem: widget.stockItem,
          quantitySold: qty,
          sellPrice: price,
          client: ClientModel.empty(),
        );

    widget.onSubmitted(sale);
  }
}

/* ────────────────── reusable number field widget ───────────────── */

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]'))],
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: validator,
    );
  }
}
