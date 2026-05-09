import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Transactions list page.
///
/// Shows all transactions with search, filter capabilities,
/// and long-press actions.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: AppTextStyles.headlineLarge(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 16),
            Text(
              'No Transactions Yet',
              style: AppTextStyles.headlineMedium(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              'Add your first transaction to get started',
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
