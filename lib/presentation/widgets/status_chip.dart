import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../domain/entities/additive.dart';

class StatusChip extends StatelessWidget {
  final SafetyStatus status;
  final bool short;
  final bool showIcon;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.status,
    this.short = false,
    this.showIcon = true,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;
    IconData icon;
    String text;

    switch (status) {
      case SafetyStatus.safe:
        bg = AppColors.safeGreenBg;
        fg = AppColors.safeGreenDark;
        border = AppColors.safeGreenBorder;
        icon = Icons.check_circle_rounded;
        text = short ? context.tr('safe') : context.tr('generallySafe');
        break;
      case SafetyStatus.caution:
        bg = AppColors.cautionOrangeBg;
        fg = AppColors.cautionOrangeDark;
        border = AppColors.cautionOrangeBorder;
        icon = Icons.error_rounded;
        text = short ? context.tr('caution') : context.tr('useWithCaution');
        break;
      case SafetyStatus.notEvaluated:
      default:
        bg = AppColors.neutralGreyBg;
        fg = AppColors.neutralGrey;
        border = AppColors.neutralGreyBorder;
        icon = Icons.help_outline_rounded;
        text = context.tr('notEvaluated');
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: short ? 10 : 12,
        vertical: short ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: fontSize + 2, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
