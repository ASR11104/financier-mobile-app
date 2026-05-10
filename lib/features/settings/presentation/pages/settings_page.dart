import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/currency_list.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/biometric_auth_service.dart';
import '../../providers/settings_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _lockToggling = false;

  @override
  Widget build(BuildContext context) {
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
            onTap: () => _showCurrencyPicker(context),
          ),
          _tile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: themeLabel,
            isDark: isDark,
            onTap: () =>
                _showThemePicker(context, prefs?.themeMode ?? 'system'),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Security', isDark),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.only(bottom: 4),
            child: SwitchListTile(
              secondary: const Icon(Icons.lock_outline, color: AppColors.primary),
              title: Text(
                'App Lock',
                style: AppTextStyles.bodyLarge(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                'Require biometric or device PIN to open',
                style: AppTextStyles.bodySmall(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              value: prefs?.isLockEnabled ?? false,
              onChanged: _lockToggling ? null : (val) => _toggleLock(val),
            ),
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

  Future<void> _toggleLock(bool enable) async {
    setState(() => _lockToggling = true);
    try {
      if (enable) {
        final auth = getIt<BiometricAuthService>();
        final canAuth = kDebugMode || await auth.canAuthenticate();
        if (!canAuth) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'No biometric or device PIN set up on this device')),
            );
          }
          return;
        }
        final ok = kDebugMode ||
            await auth.authenticate('Confirm identity to enable App Lock');
        if (!ok) return;
      }
      await ref.read(preferencesRepositoryProvider).setAppLock(enable);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _lockToggling = false);
    }
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: supportedCurrencies.length,
        itemBuilder: (_, i) {
          final c = supportedCurrencies[i];
          return ListTile(
            leading: Text(c.symbol, style: const TextStyle(fontSize: 20)),
            title: Text(c.name),
            subtitle: Text(c.code),
            onTap: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(preferencesRepositoryProvider)
                    .updateCurrency(c.code, c.symbol);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update currency')),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  void _showThemePicker(BuildContext context, String current) {
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
                  try {
                    await ref
                        .read(preferencesRepositoryProvider)
                        .updateThemeMode(v);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to update theme')),
                      );
                    }
                  }
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
