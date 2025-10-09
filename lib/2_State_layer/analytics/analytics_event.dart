part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {}

class AnalyticsInitial extends AnalyticsEvent {
  @override
  List<Object> get props => [];
}

class AnalyticsTimeWindowChanged extends AnalyticsEvent {
  final TimeWindow selectedTimeWindow;

  AnalyticsTimeWindowChanged(this.selectedTimeWindow);

  @override
  List<Object> get props => [selectedTimeWindow];
}
