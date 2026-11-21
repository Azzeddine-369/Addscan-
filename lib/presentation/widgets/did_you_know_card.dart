import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import 'source_illustration.dart';

class DidYouKnowCard extends StatelessWidget {
  final String? customFact;

  const DidYouKnowCard({
    super.key,
    this.customFact,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2E28) : const Color(0xFFEBF7F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF2E4D43) : const Color(0xFFC7EBDD),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lightbulb Icon Container
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.safeGreen.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.safeGreenDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Fact
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr('didYouKnow'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F5132),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  customFact ?? context.tr('didYouKnowFact'),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? Colors.white70 : const Color(0xFF1E4638),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Lemon illustration
          const SourceIllustration(
            iconType: 'lemon',
            size: 42,
          ),
        ],
      ),
    );
  }
}
