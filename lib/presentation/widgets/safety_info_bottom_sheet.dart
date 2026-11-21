import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class SafetyInfoBottomSheet extends StatelessWidget {
  const SafetyInfoBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const SafetyInfoBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: AppColors.primaryTeal, size: 26),
              const SizedBox(width: 10),
              Text(
                context.tr('safetyLevels'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Level 1: Generally Safe
          _buildLevelItem(
            icon: Icons.check_circle_rounded,
            iconColor: AppColors.safeGreenDark,
            bgColor: AppColors.safeGreenBg,
            borderColor: AppColors.safeGreenBorder,
            title: context.tr('generallyRecognizedAsSafe'),
            desc: context.tr('safetySafeDesc'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Level 2: Caution
          _buildLevelItem(
            icon: Icons.error_rounded,
            iconColor: AppColors.cautionOrangeDark,
            bgColor: AppColors.cautionOrangeBg,
            borderColor: AppColors.cautionOrangeBorder,
            title: context.tr('useWithCaution'),
            desc: context.tr('safetyCautionDesc'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Level 3: Not Evaluated
          _buildLevelItem(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.neutralGrey,
            bgColor: AppColors.neutralGreyBg,
            borderColor: AppColors.neutralGreyBorder,
            title: context.tr('notEvaluated'),
            desc: context.tr('safetyNotEvalDesc'),
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          // Disclaimer note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B2E28) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('medicalDisclaimerText'),
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      color: isDark ? Colors.white70 : const Color(0xFF1E4638),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? bgColor.withOpacity(0.08) : bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
