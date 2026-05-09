import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Analytics page.
///
/// Shows charts and data visualizations:
/// - Monthly expense breakdown (pie/donut chart)
/// - Income vs expense trend (bar chart)
/// - Category-wise spending breakdown
/// - Top tags analysis
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: AppTextStyles.headlineLarge(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 16),
            Text(
              'Analytics',
              style: AppTextStyles.headlineMedium(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              'Add transactions to see spending insights',
              style: AppTextStyles.bodyMedium(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
