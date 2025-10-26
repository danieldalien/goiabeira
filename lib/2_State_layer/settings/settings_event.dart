part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {}

class InitializeSettings extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class ExportSoldItemToCSV extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class ExportStockItemToCSV extends SettingsEvent {
  @override
  List<Object> get props => [];
}

