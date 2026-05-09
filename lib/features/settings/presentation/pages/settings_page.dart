import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Settings page.
///
/// Provides app configuration options:
/// - Currency selector
/// - Theme toggle (light/dark/system)
/// - Category management
/// - Tag management
/// - About
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTextStyles.headlineLarge(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('General', isDark),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.attach_money,
            title: 'Currency',
            subtitle: 'INR (₹)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Currency picker coming soon!')),
              );
            },
            isDark: isDark,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'System',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme picker coming soon!')),
              );
            },
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Data', isDark),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.category_outlined,
            title: 'Manage Categories',
            subtitle: 'Add or edit transaction categories',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category management coming soon!')),
              );
            },
            isDark: isDark,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.label_outlined,
            title: 'Manage Tags',
            subtitle: 'Add or edit transaction tags',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tag management coming soon!')),
              );
            },
            isDark: isDark,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About', isDark),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'About Finsight',
            subtitle: 'Version 0.1.0',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('About Finsight coming soon!')),
              );
            },
            isDark: isDark,
          ),
        ]
            .animate(interval: 80.ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.05),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelMedium(
          color: isDark
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
        onTap: onTap,
      ),
    );
  }
}
