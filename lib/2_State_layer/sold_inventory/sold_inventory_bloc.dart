import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/3_Domain_Layer/Interface/sell_handler_interface.dart';
import 'package:goiabeira/4_Data_Layer/Model/message_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Service/sold_item_service.dart';

part 'sold_inventory_event.dart';
part 'sold_inventory_state.dart';

class SoldInventoryBloc extends Bloc<SoldInventoryEvent, SoldInventoryState> {
  final SellHandlerInterface _sellHandler =
      GetIt.instance<SellHandlerInterface>();

  SoldInventoryBloc() : super(SoldInventoryState()) {
    on<SoldInventoryInitial>(_onSoldInventoryInitial);
    on<ResetSoldInventoryState>(_onResetSoldInventoryState);
    on<DeleteSoldItem>(_onDeleteSoldItem);
    on<UpdateSoldItem>(_onUpdateSoldItem);
    on<GetSoldItems>(_onGetSoldItems);
    on<SellItem>(_onSellItem);
  }

  void _onSoldInventoryInitial(
    SoldInventoryInitial event,
    Emitter<SoldInventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));

    final List<SoldItem> soldItems = await _sellHandler.readAllSoldItems();

    final List<SoldInventorySummaryModel> soldInventorySummary =
        _sellHandler.getInventorySummaryByItem();

    emit(
      state.copyWith(
        appState: AppState.idle,
        soldItems: soldItems,
        soldInventorySummary: soldInventorySummary,
        stateTriggered: !state.stateTriggered,
      ),
    );
  }

  void _onResetSoldInventoryState(
    ResetSoldInventoryState event,
    Emitter<SoldInventoryState> emit,
  ) {
    emit(state.copyWith(appState: AppState.idle, messages: []));
  }

  void _onDeleteSoldItem(
    DeleteSoldItem event,
    Emitter<SoldInventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    try {
      await _sellHandler.deleteSoldItem(event.item);
      final List<SoldItem> soldItems = List.from(state.soldItems);
      soldItems.removeWhere((item) => item.idSoldItem == event.item.idSoldItem);
      emit(state.copyWith(appState: AppState.idle, soldItems: soldItems));
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

  void _onUpdateSoldItem(
    UpdateSoldItem event,
    Emitter<SoldInventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));

    await _sellHandler.updateSoldItem(
      event.soldItem,
      event.soldItem.idSoldItem.toString(),
    );
    final List<SoldItem> soldItems = await _sellHandler.readAllSoldItems();
    emit(state.copyWith(appState: AppState.idle, soldItems: soldItems));
  }

  void _onGetSoldItems(
    GetSoldItems event,
    Emitter<SoldInventoryState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    final List<SoldItem> soldItems = await _sellHandler.readAllSoldItems();
    emit(state.copyWith(appState: AppState.idle, soldItems: soldItems));
  }

  void _onSellItem(SellItem event, Emitter<SoldInventoryState> emit) async {
    final List<SoldItem> soldItems = List.from(state.soldItems);
    soldItems.add(event.soldItem);
    print(
      '2 SELL BLOC. Selling item: ${event.soldItem.stockItem.title} : with Stock_ID ${event.soldItem.stockItem.id} , SELL_ID: ${event.soldItem.idSoldItem}',
    );
    emit(
      state.copyWith(
        appState: AppState.idle,
        soldItems: soldItems,
        stateTriggered: !state.stateTriggered,
      ),
    );
  }
}
