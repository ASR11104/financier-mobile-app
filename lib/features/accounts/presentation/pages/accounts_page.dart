import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Accounts overview page.
///
/// Shows cards for each account with balance (or credit limit for credit cards),
/// color-coded by type.
class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accounts',
          style: AppTextStyles.headlineLarge(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Account coming soon!')),
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
              Icons.account_balance_wallet_rounded,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 16),
            Text(
              'No Accounts Yet',
              style: AppTextStyles.headlineMedium(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              'Add your bank accounts, credit cards, or cash',
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
