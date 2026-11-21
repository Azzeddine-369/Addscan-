import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/additive.dart';
import 'source_illustration.dart';
import 'status_chip.dart';

class AdditiveCard extends StatelessWidget {
  final String code;
  final String name;
  final SafetyStatus safetyStatus;
  final String iconType;
  final String? subtitle;
  final bool shortChip;
  final VoidCallback onTap;

  const AdditiveCard({
    super.key,
    required this.code,
    required this.name,
    required this.safetyStatus,
    required this.iconType,
    this.subtitle,
    this.shortChip = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Source Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconBackground(iconType, isDark),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: SourceIllustration(
                    iconType: iconType,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),

                // E-Code & Name & Optional timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Status chip & chevron
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusChip(
                      status: safetyStatus,
                      short: shortChip,
                      showIcon: !shortChip,
                      fontSize: 11,
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconBackground(String icon, bool isDark) {
    if (isDark) return const Color(0xFF2A3635);
    switch (icon.toLowerCase()) {
      case 'lemon':
        return const Color(0xFFFEF9C3);
      case 'flask':
        return const Color(0xFFFFE4E6);
      case 'droplet':
        return const Color(0xFFDBEAFE);
      case 'curcumin':
        return const Color(0xFFFCE7F3);
      case 'leaf':
      default:
        return const Color(0xFFDCFCE7);
    }
  }
}
