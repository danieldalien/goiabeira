import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/item_category.dart';
import 'package:goiabeira/4_Data_Layer/Model/message_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/quantiy_value_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item_summary_model.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService _analyticsService = GetIt.instance<AnalyticsService>();

  AnalyticsBloc() : super(AnalyticsState()) {
    on<AnalyticsInitial>(_onAnalyticsInitial);
    on<AnalyticsTimeWindowChanged>(_onTimeWindowChanged);
    on<AnalyticsHighlightTimeWindowChanged>(_onHighlightTimeWindowChanged);
    //on<ResetAnalyticsState>(_onResetAnalyticsState);
  }

  void _onAnalyticsInitial(
    AnalyticsInitial event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    try {
      await _analyticsService.init();

      final Map<ItemCategory, QuantiyValueModel> quantityValueByCategory =
          _analyticsService.getQuantityValueByCategory();

      final List<SoldItemSummaryModel> topSellers = _analyticsService
          .getTopSellers(
            timeWindow: state.selectedHightlightTimeWindow,
            limit: 10,
          );

      emit(
        state.copyWith(
          appState: AppState.idle,
          analyzeModel: _analyticsService.getAnalyzeModelForTimeWindow(
            state.selectedTimeWindow,
          ),
          stateTriggered: !state.stateTriggered,
          quantityValueByCategory: quantityValueByCategory,
          topSellers: topSellers,
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
    emit(state.copyWith(appState: AppState.idle));
  }

  void _onTimeWindowChanged(
    AnalyticsTimeWindowChanged event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedTimeWindow: event.selectedTimeWindow,
        analyzeModel: _analyticsService.getAnalyzeModelForTimeWindow(
          event.selectedTimeWindow,
        ),
      ),
    );
  }

  void _onHighlightTimeWindowChanged(
    AnalyticsHighlightTimeWindowChanged event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedHightlightTimeWindow: event.selectedTimeWindow,
        stateTriggered: !state.stateTriggered,
      ),
    );
  }
}
