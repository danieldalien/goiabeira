import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goiabeira/0_Core/Enums/time_window.dart';
import 'package:goiabeira/1_UI_Layer/Screen/Analytics/analystic_summary.dart';
import 'package:goiabeira/1_UI_Layer/Widgets/top_selling_item_card.dart';

import 'package:goiabeira/2_State_layer/analytics/analytics_bloc.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(AnalyticsInitial());
  }

  final List<TimeWindow> timeWindowsWithoutCustom =
      TimeWindow.values.where((e) => e != TimeWindow.custom).toList();

  /* ────────────────────────── UI ────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AnalyticsBloc>().add(AnalyticsInitial());
              return Future<void>.value();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverPadding(padding: EdgeInsets.all(24)),
                SliverToBoxAdapter(
                  child: AnalysticSummary(
                    model: state.analyzeModel,
                    selectedTimeWindow: state.selectedTimeWindow,
                    items: timeWindowsWithoutCustom,
                    onSelected: (w) => _onTimeWindowSelected(context, w),
                    onRefresh: () {
                      context.read<AnalyticsBloc>().add(AnalyticsInitial());
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverList.builder(
                  itemCount: state.topSellers.length,
                  itemBuilder: (context, index) {
                    final summary = state.topSellers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TopSellingItemCard(
                        summary: summary,
                        onTap: () {
                          /* ... */
                        },
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

void _onTimeWindowSelected(BuildContext context, TimeWindow window) {
  context.read<AnalyticsBloc>().add(AnalyticsTimeWindowChanged(window));
}

/* ──────────────────────── Tile row ──────────────────────── */
