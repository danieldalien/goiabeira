part of 'sold_inventory_bloc.dart';

abstract class SoldInventoryEvent extends Equatable {}

class SoldInventoryInitial extends SoldInventoryEvent {
  @override
  List<Object> get props => [];
}

class GetSoldItems extends SoldInventoryEvent {
  @override
  List<Object> get props => [];
}

class ResetSoldInventoryState extends SoldInventoryEvent {
  @override
  List<Object> get props => [];
}

class DeleteSoldItem extends SoldInventoryEvent {
  final SoldItem item;
  DeleteSoldItem(this.item);
  @override
  List<Object> get props => [item];
}

class UpdateSoldItem extends SoldInventoryEvent {
  final SoldItem soldItem;
  UpdateSoldItem(this.soldItem);
  @override
  List<Object> get props => [soldItem];
}

class SellItem extends SoldInventoryEvent {
  final SoldItem soldItem;
  SellItem(this.soldItem);
  @override
  List<Object> get props => [soldItem];
}
