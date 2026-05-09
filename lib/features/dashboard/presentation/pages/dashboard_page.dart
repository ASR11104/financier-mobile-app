import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Dashboard — the home screen of the app.
///
/// Shows total balance across accounts, recent transactions,
/// monthly spend/income summary, and a quick-add FAB.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finsight',
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
              Icons.dashboard_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 16),
            Text(
              'Dashboard',
              style: AppTextStyles.headlineMedium(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              'Your financial overview will appear here',
              style: AppTextStyles.bodyMedium(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Transaction coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ).animate().scale(delay: 600.ms, duration: 400.ms),
    );
  }
}
