import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../providers/analytics_providers.dart';

class CategoryPieChart extends ConsumerStatefulWidget {
  const CategoryPieChart({super.key});

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(categorySpendingProvider);

    if (data.isEmpty) {
      return const EmptyState(
        icon: Icons.pie_chart_outline,
        title: 'No expense data this month',
        hint: 'Add some expenses to see spending by category',
      );
    }

    final total = data.fold(0.0, (s, c) => s + c.total);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1;
                  });
                },
              ),
              sections: data.asMap().entries.map((e) {
                final i = e.key;
                final c = e.value;
                final isTouched = i == _touchedIndex;
                final pct = total > 0 ? (c.total / total * 100) : 0;
                return PieChartSectionData(
                  color: AppColors.fromHex(c.color),
                  value: c.total,
                  title: '${pct.toStringAsFixed(0)}%',
                  radius: isTouched ? 70 : 56,
                  titleStyle: AppTextStyles.labelSmall(
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 32,
              sectionsSpace: 2,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.take(5).map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.fromHex(c.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          c.name,
                          style: AppTextStyles.labelSmall(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

}
