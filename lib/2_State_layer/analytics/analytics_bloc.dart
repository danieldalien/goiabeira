import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:goiabeira/0_Core/Enums/app_screens.dart';
import 'package:goiabeira/0_Core/Enums/app_state.dart';
import 'package:goiabeira/3_Domain_Layer/Services/analytics_service.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/message_model.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsService _analyticsService = GetIt.instance<AnalyticsService>();

  AnalyticsBloc() : super(AnalyticsState()) {
    on<AnalyticsInitial>(_onAnalyticsInitial);
    //on<ResetAnalyticsState>(_onResetAnalyticsState);
  }

  void _onAnalyticsInitial(
    AnalyticsInitial event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(appState: AppState.loading));
    try {
      await _analyticsService.init();
      final double totalStockValue = _analyticsService.getTotalStockValue();
      final double totalSoldValue = _analyticsService.getTotalSoldValue();
      final double totalProfit = _analyticsService.getTotalProfit();

      final DateTime startDate = DateTime.now();
      final DateTime oneMonthAgo = DateTime(
        startDate.year,
        startDate.month - 1,
        startDate.day,
        startDate.hour,
        startDate.minute,
        startDate.second,
        startDate.millisecond,
        startDate.microsecond,
      );

      final AnalyzeModel analyzeModel = AnalyzeModel(
        totalStockValue: totalStockValue,
        totalSoldValue: totalSoldValue,
        totalProfit: totalProfit,
        profitByPeriod: _analyticsService.getProfitByPeriod(oneMonthAgo, 7),
        totalSoldQuantity: _analyticsService.getTotalSoldQuantity(),
        totalStockQuantity: _analyticsService.getTotalStockQuantity(),
        profitThisWeek: _analyticsService.getProfitForThisWeek(),
        profitThisMonth: _analyticsService.getProfitForThisMonth(),
      );

      emit(
        state.copyWith(
          appState: AppState.idle,
          analyzeModel: analyzeModel,
          stateTriggered: !state.stateTriggered,
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
}
