part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {}

class InventoryInitial extends InventoryEvent {
  @override
  List<Object> get props => [];
}

class ResetInventoryState extends InventoryEvent {
  @override
  List<Object> get props => [];
}

class CreateStockItem extends InventoryEvent {
  final StockItem stockItem;

  CreateStockItem(this.stockItem);

  @override
  List<Object> get props => [stockItem];
}

class UpdateStockItem extends InventoryEvent {
  final StockItem stockItem;

  UpdateStockItem(this.stockItem);

  @override
  List<Object> get props => [stockItem];
}

class DeleteStockItem extends InventoryEvent {
  final StockItem stockItem;

  DeleteStockItem(this.stockItem);

  @override
  List<Object> get props => [stockItem];
}

class ReadAllStockItem extends InventoryEvent {
  @override
  ReadAllStockItem();

  @override
  List<Object> get props => [];
}

class SellStockItem extends InventoryEvent {
  final SoldItem soldItem;

  SellStockItem(this.soldItem);

  @override
  List<Object> get props => [soldItem];
}
