part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool stateTriggered;
  final AppScreens currentScreen;
  final AppState appState;
  final MessageModel message;
  final List<MessageModel> messages;
  final List<StockItem> stockItems;
  final List<SoldItem> soldItems;

  SettingsState({
    this.stateTriggered = false,
    this.currentScreen = AppScreens.settings,
    this.appState = AppState.idle,
    MessageModel? message,
    this.messages = const [],
    this.stockItems = const [],
    this.soldItems = const [],
  }) : message = message ?? MessageModel.empty(),
       super();

  SettingsState copyWith({
    bool? stateTriggered,
    AppScreens? currentScreen,
    AppState? appState,
    MessageModel? message,
    List<MessageModel>? messages,
    List<StockItem>? stockItems,
    List<SoldItem>? soldItems,
  }) {
    return SettingsState(
      stateTriggered: stateTriggered ?? this.stateTriggered,
      currentScreen: currentScreen ?? this.currentScreen,
      appState: appState ?? this.appState,
      messages: messages ?? this.messages,
      message: message ?? this.message,
      stockItems: stockItems ?? this.stockItems,
      soldItems: soldItems ?? this.soldItems,
    );
  }

  @override
  List<Object> get props => [
    stateTriggered,
    currentScreen,
    appState,
    messages,
    message,
    stockItems,
    soldItems,
  ];
}
