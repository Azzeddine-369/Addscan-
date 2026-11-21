import 'package:flutter/material.dart';

/// App color palette matching the AddiScan UI design
class AppColors {
  AppColors._();

  // Primary Branding Colors
  static const Color primaryTeal = Color(0xFF0F8B7F);
  static const Color primaryTealDark = Color(0xFF0A6B61);
  static const Color primaryTealLight = Color(0xFFE4F4F2);
  static const Color primaryTealSoft = Color(0xFFC7EBE6);

  // Status: Safe
  static const Color safeGreen = Color(0xFF10B981);
  static const Color safeGreenDark = Color(0xFF047857);
  static const Color safeGreenBg = Color(0xFFE8F8F0);
  static const Color safeGreenBorder = Color(0xFFA7F3D0);

  // Status: Caution
  static const Color cautionOrange = Color(0xFFF59E0B);
  static const Color cautionOrangeDark = Color(0xFFB45309);
  static const Color cautionOrangeBg = Color(0xFFFFF7ED);
  static const Color cautionOrangeBorder = Color(0xFFFDE68A);

  // Status: Not Evaluated / Neutral
  static const Color neutralGrey = Color(0xFF6B7280);
  static const Color neutralGreyBg = Color(0xFFF3F4F6);
  static const Color neutralGreyBorder = Color(0xFFE5E7EB);

  // Neutral Backgrounds & Cards (Light Mode)
  static const Color bgLight = Color(0xFFF8FAF9);
  static const Color cardLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color dividerLight = Color(0xFFE5E7EB);

  // Dark Mode
  static const Color bgDark = Color(0xFF111817);
  static const Color cardDark = Color(0xFF1E2827);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);
  static const Color dividerDark = Color(0xFF2D3B39);

  // Card Soft Shadow
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
