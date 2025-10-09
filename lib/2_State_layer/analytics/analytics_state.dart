part of 'analytics_bloc.dart';

class AnalyticsState extends Equatable {
  final bool stateTriggered;
  final AppScreens currentScreen;
  final AppState appState;
  final MessageModel message;
  final List<MessageModel> messages;
  final AnalyzeModel analyzeModel;
  final TimeWindow selectedTimeWindow;
  final List<SoldItemSummaryModel> topSellers;
  Map<ItemCategory, QuantiyValueModel> quantityValueByCategory;

  AnalyticsState({
    this.stateTriggered = false,
    this.currentScreen = AppScreens.analytics,
    this.appState = AppState.idle,
    MessageModel? message,
    this.messages = const [],
    this.selectedTimeWindow = TimeWindow.last30Days,
    AnalyzeModel? analyzeModel,
    this.topSellers = const [],
    this.quantityValueByCategory = const {},
  }) : message = message ?? MessageModel.empty(),
       analyzeModel = analyzeModel ?? AnalyzeModel.empty(),
       super();

  AnalyticsState copyWith({
    bool? stateTriggered,
    AppScreens? currentScreen,
    AppState? appState,
    MessageModel? message,
    List<MessageModel>? messages,
    AnalyzeModel? analyzeModel,
    TimeWindow? selectedTimeWindow,
    List<SoldItemSummaryModel>? topSellers,
    Map<ItemCategory, QuantiyValueModel>? quantityValueByCategory,
  }) {
    return AnalyticsState(
      stateTriggered: stateTriggered ?? this.stateTriggered,
      currentScreen: currentScreen ?? this.currentScreen,
      appState: appState ?? this.appState,
      analyzeModel: analyzeModel ?? this.analyzeModel,
      messages: messages ?? this.messages,
      message: message ?? this.message,
      selectedTimeWindow: selectedTimeWindow ?? this.selectedTimeWindow,
      topSellers: topSellers ?? this.topSellers,
      quantityValueByCategory:
          quantityValueByCategory ?? this.quantityValueByCategory,
    );
  }

  @override
  List<Object> get props => [
    stateTriggered,
    currentScreen,
    appState,
    messages,
    message,
    analyzeModel,
    selectedTimeWindow,
    topSellers,
    quantityValueByCategory,
  ];
}
