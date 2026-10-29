import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Pill: distance value + location icon. Figma `273:431`.
class AppDistanceTag extends StatelessWidget {
  const AppDistanceTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.md - 2,
        vertical: spacing.xs2 - 1,
      ),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.12),
            blurRadius: 1.3,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: typo.textLgRegular.copyWith(color: colors.borderPrimary),
          ),
          SizedBox(width: spacing.xs),
          Icon(Icons.location_on_outlined, size: 14, color: colors.borderPrimary),
        ],
      ),
    );
  }
}
