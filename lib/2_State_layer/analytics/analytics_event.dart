part of 'analytics_bloc.dart';

abstract class AnalyticsEvent extends Equatable {}

class AnalyticsInitial extends AnalyticsEvent {
  @override
  List<Object> get props => [];
}
