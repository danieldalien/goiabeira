import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goiabeira/0_Core/Config/app_colors.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Inventory/sell_item_formular.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Inventory/sell_item_formular_old.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Inventory/stock_item_formular_screen.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/custom_snack_bars_class.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/General/search_field_widget_old.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/search_field_widget.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/stock_item_card.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/stock_item_card_v2.dart';
import 'package:goiabeira/2_State_layer/inventory/inventory_bloc.dart';
import 'package:goiabeira/2_State_layer/sold_inventory/sold_inventory_bloc.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isFormular = false;
  bool _isSellItemFormular = false;
  StockItem? _selectedStockItem;
  final TextEditingController _searchFieldListController =
      TextEditingController();

  @override
  void initState() {
    print('InventoryScreen initState');
    super.initState();
    // Trigger the initial inventory load.
    context.read<InventoryBloc>().add(InventoryInitial());
  }

  @override
  void dispose() {
    print('InventoryScreen dispose');
    _searchFieldListController.dispose();
    super.dispose();
  }

  void _screenListener(BuildContext context, InventoryState state) {
    if (state.appState == AppState.storingSuccess) {
      CustomSnackBarClass.storageStateSnackBar(
        context: context,
        isSuccess: true,
        successMessage: state.message.message,
        onDismiss: _onResetInventoryState,
      );
      setState(() {
        _isFormular = false;
        _selectedStockItem = null;
      });
    } else if (state.appState == AppState.storingFailed) {
      CustomSnackBarClass.storageStateSnackBar(
        context: context,
        isSuccess: false,
        errorMessage: state.message.message,
        onDismiss: _onResetInventoryState,
      );
    } else if (state.appState == AppState.error) {
      // Handle error state if needed.
    } else if (state.appState == AppState.loading) {
      // Optionally show a loading indicator.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: _screenListener,
      child: Stack(
        children: [
          _buildCurrentScreen(),
          Positioned(
            right: 10,
            bottom: 10,
            child: _buildFloatingActionButton(),
          ),
          if (_isSellItemFormular && _selectedStockItem != null)
            Center(child: _buildSellItemFormular()),
        ],
      ),
    );
  }

  /// Resets the inventory state by dispatching a reset event.
  void _onResetInventoryState() {
    context.read<InventoryBloc>().add(ResetInventoryState());
  }

  /// When a stock item is selected for selling, update state to show the sell formular.
  void _onSellStockItem(StockItem stockItem) async {
    await _openSellItemDialog(context, stockItem);
  }

  /// Handles the sell action by dispatching the sell event.
  void _sellItem(SoldItem item) {
    print(
      '1. Selling item: ${item.stockItem.title} : with Stock_ID ${item.stockItem.id} , SELL_ID: ${item.idSoldItem}',
    );

    context.read<InventoryBloc>().add(SellStockItem(item));
    context.read<SoldInventoryBloc>().add(
      SellItem(item),
    ); // Reset the state after selling.
  }

  /// Cancels the sell item formular.
  void _onCancelSellItem() {
    setState(() {
      _isSellItemFormular = false;
    });
  }

  /// Handles editing a stock item by setting it as selected and showing the edit form.
  void _onEditStockItem(StockItem stockItem) {
    setState(() {
      _selectedStockItem = stockItem;
      _isFormular = true;
    });
  }

  /// Callback for when the stock item form is submitted.
  void _onSubmitted(BuildContext context, StockItem stockItem) {
    context.read<InventoryBloc>().add(CreateStockItem(stockItem));
  }

  /// Callback for when the stock item is deleted.
  void _onDelete(BuildContext context, StockItem stockItem) {
    context.read<InventoryBloc>().add(DeleteStockItem(stockItem));
  }

  /// Determines which screen to display: the inventory list or the stock item form.
  Widget _buildCurrentScreen() {
    return _isFormular
        ? _buildFormularScreen(_selectedStockItem)
        : _buildInventoryScreen();
  }

  /// Builds the stock item form screen.
  Widget _buildFormularScreen(StockItem? stockItem) {
    return StockItemFormularScreen(
      stockItem: stockItem,
      onSubmitted: _onSubmitted,
      onDelete: _onDelete,
    );
  }

  /// Builds the sell item formular overlay.
  Widget _buildSellItemFormular() {
    const double margin = 30;
    const double padding = 30;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(margin),
          padding: const EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.unfocusedBorderColor),
          ),
          child: SellItemFormularOld(
            stockItem: _selectedStockItem!,
            onSubmitted: _sellItem,
            soldItem: null,
          ),
        ),
        Positioned(
          right: margin,
          top: padding,
          child: IconButton(
            icon: const Icon(Icons.close, color: AppColors.errorRed),
            onPressed: _onCancelSellItem,
          ),
        ),
      ],
    );
  }

  Future<void> _openSellItemDialog(BuildContext context, StockItem item) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            clipBehavior: Clip.antiAlias,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Sell item'),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                    tooltip: 'Close',
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: SellItemFormular(
                  stockItem: item,
                  onSubmitted: (sold) {
                    _sellItem(sold);
                    Navigator.pop(ctx);
                  },
                  soldItem: null,
                ),
              ),
            ),
          ),
    );
  }

  List<StockItem> _getFilteredStockItems(List<StockItem> stockItems) {
    final String searchQuery = _searchFieldListController.text;

    return _filterStockItems(stockItems, searchQuery);
  }

  /// Builds the inventory list screen using a BlocBuilder.
  Widget _buildInventoryScreen() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SearchFieldWidget(
                  controller: _searchFieldListController,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _getFilteredStockItems(state.stockItems).length,
                  itemBuilder: (context, index) {
                    final stockItem =
                        _getFilteredStockItems(state.stockItems)[index];
                    return StockItemCardV2(
                      stockItem: stockItem,
                      onSell: () => _onSellStockItem(stockItem),
                      onEdit: () => _onEditStockItem(stockItem),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the floating action button to toggle the stock item form.
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      //backgroundColor: Colors.blue,
      onPressed: () {
        setState(() {
          if (_isFormular) {
            _selectedStockItem = null; // Reset selected stock item
          }
          _isFormular = !_isFormular;
        });
      },
      child: Icon(_isFormular ? Icons.close : Icons.add),
    );
  }

  List<StockItem> _filterStockItems(List<StockItem> stockItem, String query) {
    final String lowerCaseQuery = query.toLowerCase();
    return stockItem.where((stockItem) {
      return stockItem.title.toLowerCase().contains(lowerCaseQuery) ||
          stockItem.category.name.toLowerCase().contains(lowerCaseQuery) ||
          stockItem.id.toString().toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}
