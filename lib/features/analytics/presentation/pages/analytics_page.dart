import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../budgets/presentation/pages/budgets_view.dart';
import '../../../goals/presentation/pages/goals_view.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_bar_chart.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: AppTextStyles.headlineLarge()),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Insights'),
            Tab(text: 'Budgets'),
            Tab(text: 'Goals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _InsightsView(),
          BudgetsView(),
          GoalsView(),
        ],
      ),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall()),
      ],
    );
  }
}
