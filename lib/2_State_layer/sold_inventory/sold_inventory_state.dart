part of 'sold_inventory_bloc.dart';

class SoldInventoryState extends Equatable {
  final bool stateTriggered;
  final AppScreens currentScreen;
  final AppState appState;
  final MessageModel message;
  final List<MessageModel> messages;
  final List<SoldItem> soldItems;
  final List<SoldInventorySummaryModel> soldInventorySummary;
  SoldInventoryState({
    this.stateTriggered = false,
    this.currentScreen = AppScreens.soldInventory,
    this.appState = AppState.idle,
    MessageModel? message,
    this.messages = const [],
    this.soldItems = const [],
    this.soldInventorySummary = const [],
  }) : message = message ?? MessageModel.empty(),
       super();

  SoldInventoryState copyWith({
    bool? stateTriggered,
    AppScreens? currentScreen,
    AppState? appState,
    MessageModel? message,
    List<MessageModel>? messages,
    List<SoldItem>? soldItems,
    List<SoldInventorySummaryModel>? soldInventorySummary,
  }) {
    return SoldInventoryState(
      stateTriggered: stateTriggered ?? this.stateTriggered,
      currentScreen: currentScreen ?? this.currentScreen,
      appState: appState ?? this.appState,
      messages: messages ?? this.messages,
      soldItems: soldItems ?? this.soldItems,
      soldInventorySummary: soldInventorySummary ?? this.soldInventorySummary,
    );
  }

  @override
  List<Object> get props => [
    stateTriggered,
    currentScreen,
    appState,
    messages,
    soldItems,
    soldInventorySummary,
  ];
}
