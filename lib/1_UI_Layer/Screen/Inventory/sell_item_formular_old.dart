import 'package:flutter/material.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Config/app_text_style.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Buttons/icon_text_button.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/price_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/Formular/Stock_Item/quantity_input.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/height_spacer.dart';
import 'package:goiabeira/4_Data_Layer/Model/client_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class SellItemFormularOld extends StatefulWidget {
  final StockItem stockItem;
  final SoldItem? soldItem;
  final Function(SoldItem) onSubmitted;
  const SellItemFormularOld({
    required this.stockItem,
    required this.onSubmitted,
    this.soldItem,
    super.key,
  });

  @override
  State<SellItemFormularOld> createState() => _SellItemFormularOldState();
}

class _SellItemFormularOldState extends State<SellItemFormularOld> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();

  @override
  void initState() {
    print('SellItemFormular initState');
    _initQuantity();
    _initSellPrice();
    super.initState();
  }

  void _initQuantity() {
    if (widget.soldItem != null && widget.soldItem!.quantity > 0) {
      _quantityController.text = widget.soldItem!.quantity.toString();
    } else {
      _quantityController.text = '1';
    }
  }

  void _initSellPrice() {
    if (widget.soldItem != null) {
      _sellPriceController.text = widget.soldItem!.sellPrice.toString();
    } else {
      _sellPriceController.text = widget.stockItem.sellPrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('SellItemFormular build');
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Sell ${widget.stockItem.title}', style: AppTextStyle.heading1),
          const HeightSpacer(),
          QuantityInput(
            initialValue: _quantityController.text,
            onChanged: _onQuantityChange,
          ),
          const HeightSpacer(),
          PriceInput(
            initialValue: _sellPriceController.text,
            onChanged: _onSellPriceChange,
          ),
          const HeightSpacer(),
          _buildSellButton(),
        ],
      ),
    );
  }

  void _onSellPriceChange(String value) {
    setState(() {
      _sellPriceController.text = value;
    });
  }

  void _onQuantityChange(String value) {
    _quantityController.text = value;
  }

  void _onSubmit() {
    if (widget.soldItem != null) {
      final SoldItem soldItem = widget.soldItem!.copyWith(
        quantitySold: int.parse(_quantityController.text),
        sellPrice: double.parse(_sellPriceController.text),
      );
      widget.onSubmitted(soldItem);
    } else {
      final SoldItem soldItem = SoldItem(
        stockItem: widget.stockItem,
        sellPrice: double.parse(_sellPriceController.text),
        quantitySold: int.parse(_quantityController.text),
        client: ClientModel.empty(),
      );
      widget.onSubmitted(soldItem);
    }
  }

  Widget _buildSellButton() {
    return IconTextButton(
      text: 'Sell',
      icon: Icons.sell,
      backgroundColor: AppColors.generalButtonBackground,
      textStyle: AppTextStyle.defaultText,
      onTap: _onSubmit,
    );
  }
}
