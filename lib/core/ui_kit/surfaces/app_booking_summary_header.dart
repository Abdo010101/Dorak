import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../media/app_avatar.dart';

/// Selected center / doctor summary at the top of booking steps. Figma `276:3525`.
class AppBookingSummaryHeader extends StatelessWidget {
  const AppBookingSummaryHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      height: 78,
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.sm, spacing.sm, spacing.lg - 2, spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.neutral25,
        borderRadius: BorderRadius.circular(radii.medium),
        border: Border.all(color: colors.fieldBorder),
      ),
      child: Row(
        children: [
          AppAvatar(
            imageAsset: imageAsset,
            imageUrl: imageUrl,
            size: 62,
            radius: radii.medium,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: typo.titleSm.copyWith(color: colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: spacing.xs),
                Text(
                  subtitle,
                  style: typo.textMdRegular.copyWith(color: colors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
