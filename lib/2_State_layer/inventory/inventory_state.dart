part of 'inventory_bloc.dart';

class InventoryState extends Equatable {
  final AppScreens currentScreen;
  final AppState appState;
  final MessageModel message;
  final List<MessageModel> messages;
  final List<StockItem> stockItems;
  final List<ItemCategory> itemCategories;

  InventoryState({
    this.currentScreen = AppScreens.inventory,
    this.appState = AppState.idle,
    MessageModel? message,
    this.messages = const [],
    this.stockItems = const [],
    this.itemCategories = const [],
  }) : message = message ?? MessageModel.empty(),
       super();

  InventoryState copyWith({
    AppScreens? currentScreen,
    AppState? appState,
    MessageModel? message,
    List<MessageModel>? messages,
    List<StockItem>? stockItems,
    List<ItemCategory>? itemCategories,
  }) {
    return InventoryState(
      currentScreen: currentScreen ?? this.currentScreen,
      appState: appState ?? this.appState,
      messages: messages ?? this.messages,
      stockItems: stockItems ?? this.stockItems,
      itemCategories: itemCategories ?? this.itemCategories,
    );
  }

  @override
  List<Object> get props => [
    currentScreen,
    appState,
    messages,
    stockItems,
    itemCategories,
    message,
  ];
}
