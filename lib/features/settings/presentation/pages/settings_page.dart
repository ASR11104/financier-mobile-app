import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/currency_list.dart';
import '../../providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefsAsync = ref.watch(preferencesProvider);
    final prefs = prefsAsync.valueOrNull;

    final currencyLabel =
        prefs != null ? '${prefs.currencyCode} (${prefs.currencySymbol})' : '…';
    final themeLabel = _themeModeLabel(prefs?.themeMode ?? 'system');

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.headlineLarge()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('General', isDark),
          const SizedBox(height: 8),
          _tile(
            context,
            icon: Icons.attach_money,
            title: 'Currency',
            subtitle: currencyLabel,
            isDark: isDark,
            onTap: () => _showCurrencyPicker(context, ref),
          ),
          _tile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: themeLabel,
            isDark: isDark,
            onTap: () => _showThemePicker(context, ref, prefs?.themeMode ?? 'system'),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Data', isDark),
          const SizedBox(height: 8),
          _tile(
            context,
            icon: Icons.category_outlined,
            title: 'Manage Categories',
            subtitle: 'Add or edit transaction categories',
            isDark: isDark,
            onTap: () => context.push('/settings/categories'),
          ),
          _tile(
            context,
            icon: Icons.label_outlined,
            title: 'Manage Tags',
            subtitle: 'Add or edit transaction tags',
            isDark: isDark,
            onTap: () => context.push('/settings/tags'),
          ),
          const SizedBox(height: 24),
          _sectionHeader('About', isDark),
          const SizedBox(height: 8),
          _tile(
            context,
            icon: Icons.info_outline,
            title: 'About Finsight',
            subtitle: 'Version ${AppConstants.appVersion}',
            isDark: isDark,
            onTap: () => showAboutDialog(
              context: context,
              applicationName: AppConstants.appName,
              applicationVersion: AppConstants.appVersion,
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: supportedCurrencies.length,
        itemBuilder: (_, i) {
          final c = supportedCurrencies[i];
          return ListTile(
            leading: Text(c.symbol,
                style: const TextStyle(fontSize: 20)),
            title: Text(c.name),
            subtitle: Text(c.code),
            onTap: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(preferencesRepositoryProvider)
                  .updateCurrency(c.code, c.symbol);
            },
          );
        },
      ),
    );
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, String current) {
    final options = [
      ('system', 'System default'),
      ('light', 'Light'),
      ('dark', 'Dark'),
    ];
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) {
            return RadioListTile<String>(
              title: Text(opt.$2),
              value: opt.$1,
              // ignore: deprecated_member_use
              groupValue: current,
              // ignore: deprecated_member_use
              onChanged: (v) async {
                Navigator.of(ctx).pop();
                if (v != null) {
                  await ref
                      .read(preferencesRepositoryProvider)
                      .updateThemeMode(v);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static String _themeModeLabel(String mode) {
    return switch (mode) {
      'light' => 'Light',
      'dark' => 'Dark',
      _ => 'System',
    };
  }

  Widget _sectionHeader(String title, bool isDark) {
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

  Widget _tile(
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
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title,
            style: AppTextStyles.bodyLarge(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary)),
        subtitle: Text(subtitle,
            style: AppTextStyles.bodySmall(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)),
        trailing: Icon(Icons.chevron_right,
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary),
        onTap: onTap,
      ),
    );
  }
}
