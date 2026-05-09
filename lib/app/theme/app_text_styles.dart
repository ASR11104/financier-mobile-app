import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Finsight typography using Inter font family.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme {
    return GoogleFonts.interTextTheme();
  }

  // ─── Display ──────────────────────────────────────────────────
  static TextStyle displayLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle displayMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: color,
      );

  // ─── Headlines ────────────────────────────────────────────────
  static TextStyle headlineLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle headlineMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headlineSmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // ─── Body ─────────────────────────────────────────────────────
  static TextStyle bodyLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodyMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  // ─── Labels ───────────────────────────────────────────────────
  static TextStyle labelLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle labelMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle labelSmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: color,
      );

  // ─── Amount Display ───────────────────────────────────────────
  static TextStyle amountLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle amountMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle amountSmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );
}
