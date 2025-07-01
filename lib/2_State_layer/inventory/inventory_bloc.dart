import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/stock_handler_interface.dart';
import 'package:goiabeira/4_Data_Layer/Interface/item_category_repo.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/message_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final StockHandlerInterface _stockHandler =
      GetIt.instance<StockHandlerInterface>();

  final SellHandlerInterface _sellHandler =
      GetIt.instance<SellHandlerInterface>();

  final ItemCategoryRepo _itemCategoryHandler =
      GetIt.instance<ItemCategoryRepo>();

  InventoryBloc() : super(InventoryState()) {
    on<InventoryInitial>(_onInventoryInitial);
    on<ResetInventoryState>(_onResetInventoryState);
    on<CreateStockItem>(_onCreateStockItem);
    on<UpdateStockItem>(_onUpdateStockItem);
    on<DeleteStockItem>(_onDeleteStockItem);
    on<ReadAllStockItem>(_onReadAllStockItem);
    on<SellStockItem>(_onSellStockItem);
  }

  void _onInventoryInitial(
    InventoryInitial event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    List<Future> futures = [
      _stockHandler.readAllStockItems(),
      _itemCategoryHandler.getItemCategories(),
    ];
    await Future.wait(futures)
        .then((List results) {
          final List<StockItem> stockItems = results[0] as List<StockItem>;
          final List<ItemCategory> itemCategories =
              results[1] as List<ItemCategory>;

          emit(
            state.copyWith(
              appState: AppState.idle,
              stockItems: stockItems,
              itemCategories: itemCategories,
            ),
          );
        })
        .catchError((error) {
          emit(
            state.copyWith(
              appState: AppState.error,
              messages: [
                MessageModel(
                  message: error.toString(),
                  type: MessageType.error,
                ),
              ],
            ),
          );
        });
  }

  void _onResetInventoryState(
    ResetInventoryState event,
    Emitter<InventoryState> emit,
  ) {
    emit(state.copyWith(appState: AppState.idle, messages: []));
  }

  void _onCreateStockItem(
    CreateStockItem event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));

    try {
      await _stockHandler.createStockItem(event.stockItem);
      List<StockItem> items = List<StockItem>.from(state.stockItems);
      items.removeWhere(
        (StockItem stockItem) => stockItem.id == event.stockItem.id,
      );
      items.add(event.stockItem);
      emit(
        state.copyWith(
          appState: AppState.storingSuccess,
          messages: [
            MessageModel(
              message: 'Item criado com sucesso',
              type: MessageType.success,
            ),
          ],
          stockItems: items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          appState: AppState.error,
          messages: [
            MessageModel(message: e.toString(), type: MessageType.error),
          ],
        ),
      );
    }
  }

  void _onUpdateStockItem(UpdateStockItem event, Emitter<InventoryState> emit) {
    emit(state.copyWith(appState: AppState.loading));
    _stockHandler.updateStockItem(
      event.stockItem,
      event.stockItem.id.toString(),
    );
    final List<StockItem> updatedStockItems =
        state.stockItems
            .map(
              (StockItem stockItem) =>
                  stockItem.id == event.stockItem.id
                      ? event.stockItem
                      : stockItem,
            )
            .toList();
    emit(
      state.copyWith(appState: AppState.idle, stockItems: updatedStockItems),
    );
  }

  void _onDeleteStockItem(
    DeleteStockItem event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    final List<StockItem> updatedStockItems =
        state.stockItems
            .where((StockItem stockItem) => stockItem.id != event.stockItem.id)
            .toList();
    await _stockHandler.deleteStockItem(event.stockItem);
    emit(
      state.copyWith(appState: AppState.idle, stockItems: updatedStockItems),
    );
  }

  void _onReadAllStockItem(
    ReadAllStockItem event,
    Emitter<InventoryState> emit,
  ) {
    emit(state.copyWith(appState: AppState.loading));
    emit(state.copyWith(appState: AppState.idle, stockItems: state.stockItems));
  }

  void _onSellStockItem(
    SellStockItem event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));

    // Check if the quantity sold is greater than the available stock
    if (event.soldItem.quantitySold > event.soldItem.stockItem.quantity) {
      emit(
        state.copyWith(
          appState: AppState.error,
          message: MessageModel(
            message: 'Quantidade vendida maior que a quantidade em estoque',
            type: MessageType.error,
          ),
        ),
      );
      return;
    }
    try {
      print(
        '3 INVENTORY BLOC. Selling item: ${event.soldItem.stockItem.title} : with Stock_ID ${event.soldItem.stockItem.id} , SELL_ID: ${event.soldItem.idSoldItem}',
      );
      await Future.wait([
        _sellHandler.createSoldItem(event.soldItem),
        _stockHandler.sellStockItem(
          event.soldItem.stockItem,
          event.soldItem.quantitySold,
        ),
      ]);
      List<StockItem> items = await _stockHandler.stockItems();
      emit(
        state.copyWith(
          appState: AppState.storingSuccess,
          stockItems: await _stockHandler.stockItems(),
          message: MessageModel(
            message: 'Item vendido com sucesso',
            type: MessageType.success,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          appState: AppState.error,
          message: MessageModel(message: e.toString(), type: MessageType.error),
        ),
      );
    }
  }
}
