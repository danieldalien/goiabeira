import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/4_Data_Layer/Model/message_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';
import 'package:goiabeira/4_Data_Layer/Model/stock_item.dart';
import 'package:goiabeira/4_Data_Layer/Utility/my_csv_exporter.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final MyCsvExporter myCsvExporter;
  Stream<List<StockItem>> stockItemStream;
  Stream<List<SoldItem>> soldItemStream;
  SettingsBloc({
    required this.myCsvExporter,
    required this.stockItemStream,
    required this.soldItemStream,
  }) : super(SettingsState()) {
    on<InitializeSettings>(_onInitializeSettings);
    on<ExportSoldItemToCSV>(_onExportSoldItemToCSV);
    on<ExportStockItemToCSV>(_onExportStockItemToCSV);
  }

  void _onInitializeSettings(
    InitializeSettings event,
    Emitter<SettingsState> emit,
  ) async {
    // Handle initialization logic
    // Start managed subscriptions; no manual cancel needed.
    await emit.forEach<List<StockItem>>(
      stockItemStream,
      onData:
          (items) => state.copyWith(appState: AppState.idle, stockItems: items),
      onError: (_, __) => state.copyWith(appState: AppState.error),
    );

    await emit.forEach<List<SoldItem>>(
      soldItemStream,
      onData:
          (items) => state.copyWith(appState: AppState.idle, soldItems: items),
      onError: (_, __) => state.copyWith(appState: AppState.error),
    );
    emit(state.copyWith(appState: AppState.idle));
  }

  void _onExportSoldItemToCSV(
    ExportSoldItemToCSV event,
    Emitter<SettingsState> emit,
  ) {
    // Handle export sold items to CSV logic
    myCsvExporter.exportSoldItemsToCsv(state.soldItems);
  }

  void _onExportStockItemToCSV(
    ExportStockItemToCSV event,
    Emitter<SettingsState> emit,
  ) {
    // Handle export stock items to CSV logic
    myCsvExporter.exportStockItemsToCsv(state.stockItems);
  }
}
