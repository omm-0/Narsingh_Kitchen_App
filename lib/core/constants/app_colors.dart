import 'package:flutter/material.dart';

/// Global design tokens — FoodieExpress.
abstract final class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color primaryBrown = Color(0xFF8D4E1F);
  static const Color background = Color(0xFFF8F8F8);
  static const Color whiteSurface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color lightPinkBg = Color(0xFFFFF1F1);
  static const Color lightOrangeBg = Color(0xFFFFE8D1);
  static const Color lightBrownBg = Color(0xFFEAD9C7);
  static const Color starYellow = Color(0xFFFFB400);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color dividerGray = Color(0xFFE5E5E5);
  static const Color lightGrayBg = Color(0xFFF2F2F2);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];
}
