import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: AppTextStyles.headlineLarge()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Income vs Expenses — Last 6 Months',
                style: AppTextStyles.headlineSmall()),
            const SizedBox(height: 4),
            const Row(
              children: [
                _LegendDot(color: Color(0xFF00C853), label: 'Income'),
                SizedBox(width: 12),
                _LegendDot(color: Color(0xFFFF5252), label: 'Expense'),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 220, child: MonthlyBarChart()),
            const SizedBox(height: 24),
            Text('This Month\'s Spending by Category',
                style: AppTextStyles.headlineSmall()),
            const SizedBox(height: 12),
            const SizedBox(height: 200, child: CategoryPieChart()),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall()),
      ],
    );
  }
}
