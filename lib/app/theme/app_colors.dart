import 'package:flutter/material.dart';

/// Finsight color palette — premium, modern design.
class AppColors {
  AppColors._();

  // ─── Brand Colors ─────────────────────────────────────────────
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9D97FF);
  static const primaryDark = Color(0xFF4A42E8);

  static const secondary = Color(0xFF00D9A6);
  static const secondaryLight = Color(0xFF5DFFD4);
  static const secondaryDark = Color(0xFF00A87E);

  // ─── Semantic Colors ──────────────────────────────────────────
  static const income = Color(0xFF00C853);
  static const expense = Color(0xFFFF5252);
  static const investment = Color(0xFFFF9800);
  static const transfer = Color(0xFF2196F3);

  // ─── Dark Theme ───────────────────────────────────────────────
  static const darkBackground = Color(0xFF0D0D1A);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkSurfaceVariant = Color(0xFF252540);
  static const darkCardColor = Color(0xFF1E1E35);

  static const darkTextPrimary = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFFB0B0C8);
  static const darkTextTertiary = Color(0xFF6B6B8A);
  static const darkDivider = Color(0xFF2A2A45);

  // ─── Light Theme ──────────────────────────────────────────────
  static const lightBackground = Color(0xFFF8F9FE);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF0F1F8);
  static const lightCardColor = Color(0xFFFFFFFF);

  static const lightTextPrimary = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF6B6B8A);
  static const lightTextTertiary = Color(0xFF9E9EBF);
  static const lightDivider = Color(0xFFE8E8F0);

  // ─── Account Type Colors ──────────────────────────────────────
  static const bankAccount = Color(0xFF2196F3);
  static const creditCard = Color(0xFFE91E63);
  static const cash = Color(0xFF4CAF50);
  static const wallet = Color(0xFFFF9800);

  /// Parses a `#RRGGBB` hex string into a [Color], falling back to [primary].
  static Color fromHex(String hex) {
    try {
      final sanitized = hex.replaceAll('#', '');
      return Color(int.parse('FF$sanitized', radix: 16));
    } catch (_) {
      return primary;
    }
  }
}
