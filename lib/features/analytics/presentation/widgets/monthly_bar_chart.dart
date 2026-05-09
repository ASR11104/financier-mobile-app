import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../providers/analytics_providers.dart';

class MonthlyBarChart extends ConsumerWidget {
  const MonthlyBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(monthlyTotalsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    if (data.every((m) => m.income == 0 && m.expense == 0)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No data yet'),
        ),
      );
    }

    final maxY = data
        .expand((m) => [m.income, m.expense])
        .fold(0.0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.2,
          groupsSpace: 12,
          barGroups: data.asMap().entries.map((e) {
            final i = e.key;
            final m = e.value;
            return BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: m.income,
                  color: AppColors.income,
                  width: 10,
                  borderRadius: BorderRadius.circular(3),
                ),
                BarChartRodData(
                  toY: m.expense,
                  color: AppColors.expense,
                  width: 10,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (x, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    data[x.toInt()].label,
                    style: AppTextStyles.labelSmall(color: labelColor),
                  ),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (v, meta) => Text(
                  Formatters.formatCompact(v),
                  style: AppTextStyles.labelSmall(color: labelColor),
                ),
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY > 0 ? maxY / 4 : 1,
            getDrawingHorizontalLine: (v) => FlLine(
              color: (isDark ? AppColors.darkDivider : AppColors.lightDivider),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
