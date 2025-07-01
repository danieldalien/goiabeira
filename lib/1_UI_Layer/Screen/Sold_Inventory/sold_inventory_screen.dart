import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/sold_item_card.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/sold_item_card_v2.dart';
import 'package:goiabeira/2_State_layer/sold_inventory/sold_inventory_bloc.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_inventory_summary_model.dart';
import 'package:goiabeira/4_Data_Layer/Model/sold_item.dart';

class SoldInventoryScreen extends StatefulWidget {
  const SoldInventoryScreen({super.key});

  @override
  State<SoldInventoryScreen> createState() => _SoldInventoryScreenState();
}

class _SoldInventoryScreenState extends State<SoldInventoryScreen> {
  @override
  void initState() {
    context.read<SoldInventoryBloc>().add(SoldInventoryInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SoldInventoryBloc, SoldInventoryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 100),
            Center(
              child: FilledButton.icon(
                onPressed:
                    () => context.read<SoldInventoryBloc>().add(
                      SoldInventoryInitial(),
                    ),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),

            //_buildTextButton(),
            BlocBuilder<SoldInventoryBloc, SoldInventoryState>(
              builder: (context, state) {
                return Expanded(
                  child:
                  //_buildSoldItemList(_shortenSoldItems(state.soldItems)),
                  _buildSoldInventorySummaryList(state.soldInventorySummary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldItemList(List<SoldItem> soldItems) {
    if (soldItems.isEmpty) {
      return Center(
        child: Text(
          'No sold items found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: soldItems.length,
      itemBuilder: (context, index) {
        return SoldItemCard(
          soldItem: soldItems[index],
          onEdit: () {
            // TODO: Implement edit functionality
          },
          onDelete: () {
            _onDeleteSoldItem(soldItems[index]);
          },
          onViewDetails: () {
            // TODO: Implement view details functionality
          },
        );
      },
    );
  }

  Widget _buildSoldInventorySummaryList(
    List<SoldInventorySummaryModel> summaryList,
  ) {
    if (summaryList.isEmpty) {
      return Center(
        child: Text(
          'No sold inventory summary found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: summaryList.length,
      itemBuilder: (context, index) {
        return _buildInventoryCard(summaryModel: summaryList[index]);
      },
    );
  }

  Widget _buildInventoryCard({
    required SoldInventorySummaryModel summaryModel,
  }) {
    return SoldBaseInventoryCard(summaryModel: summaryModel, onTap: (id) {});
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: () => context.read<SoldInventoryBloc>().add(GetSoldItems()),

      child: Text('test'),
    );
  }

  void _onResetSoldInventoryState() {
    context.read<SoldInventoryBloc>().add(ResetSoldInventoryState());
  }

  void _onDeleteSoldItem(SoldItem soldItem) {
    context.read<SoldInventoryBloc>().add(DeleteSoldItem(soldItem));
  }

  // Shortens list by adding quantity of items with same id.
  List<SoldItem> _shortenSoldItems(List<SoldItem> soldItems) {
    List<SoldItem> shortenedList = [];
    for (SoldItem item in soldItems) {
      // Skip IDs we’ve already processed
      if (shortenedList.any((SoldItem i) => _isSameItem(i, item))) {
        continue;
      }
      final lastSellDate =
          soldItems.lastWhere((i) => _isSameItem(i, item)).sellDate;

      int totalQuantity = soldItems
          .where((i) => _isSameItem(i, item))
          .fold(0, (sum, i) => sum + i.quantitySold);
      shortenedList.add(
        item.copyWith(quantitySold: totalQuantity, sellDate: lastSellDate),
      );
    }
    return shortenedList;
  }

  bool _isSameItem(SoldItem item1, SoldItem item2) {
    return item1.stockItem.title == item2.stockItem.title &&
        item1.sellPrice == item2.sellPrice;
  }
}
