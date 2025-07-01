import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:goiabeira/2_State_layer/analytics/analytics_bloc.dart';
import 'package:goiabeira/4_Data_Layer/Model/analyze_model.dart';

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

  /* ────────────────────────── UI ────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh:
                () async =>
                    context.read<AnalyticsBloc>().add(AnalyticsInitial()),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: _AnalyticsCard(model: state.analyzeModel),
            ),
          );
        },
      ),
    );
  }
}

/* ────────────────────────── Card ────────────────────────── */

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.model});

  final AnalyzeModel model;

  static const _gap = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0, // flat per M3
      surfaceTintColor: scheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.titleLarge),
            _gap,
            _DataTile(
              icon: Icons.store,
              label: 'Total stock value',
              value: model.totalStockValue.toStringAsFixed(2),
            ),
            _DataTile(
              icon: Icons.inventory_2,
              label: 'Total stock quantity',
              value: '${model.totalStockQuantity}',
            ),
            _DataTile(
              icon: Icons.shopping_cart,
              label: 'Total sold value',
              value: (model.totalSoldValue).toStringAsFixed(2),
            ),
            _DataTile(
              icon: Icons.attach_money,
              label: 'Total profit',
              value: (model.totalProfit).toStringAsFixed(2),
            ),
            _DataTile(
              icon: Icons.sell,
              label: 'Total sold quantity',
              value: '${model.totalSoldQuantity}',
            ),
            _DataTile(
              icon: Icons.trending_up,
              label: 'Profit this week',
              value: (model.profitThisWeek).toStringAsFixed(2),
            ),
            _DataTile(
              icon: Icons.calendar_month,
              label: 'Profit this month',
              value: (model.profitThisMonth).toStringAsFixed(2),
            ),
            const Divider(height: 32),
            Center(
              child: FilledButton.icon(
                onPressed:
                    () => context.read<AnalyticsBloc>().add(AnalyticsInitial()),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ──────────────────────── Tile row ──────────────────────── */

class _DataTile extends StatelessWidget {
  const _DataTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      dense: true,
      leading: Icon(icon, color: scheme.primary),
      title: Text(label, style: textTheme.bodyMedium),
      trailing: Text(
        value,
        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
