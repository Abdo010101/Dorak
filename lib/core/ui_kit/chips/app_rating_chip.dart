import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Pill: star icon + rating value + optional review count.
/// Used on cards, media overlays, doctor rows. RTL-first via Row + Directional padding.
class AppRatingChip extends StatelessWidget {
  const AppRatingChip({
    super.key,
    required this.rating,
    this.reviewCount,
    this.background,
    this.filledStars = 1,
    this.outlineStars = 0,
    this.compact = true,
  });

  final String rating;
  final String? reviewCount;
  final Color? background;
  final int filledStars;
  final int outlineStars;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.md - 2,
        vertical: spacing.xs2 - 2,
      ),
      decoration: BoxDecoration(
        color: background ?? colors.neutral50,
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
          if (reviewCount != null) ...[
            Text(
              '($reviewCount)',
              style: typo.textMdRegular.copyWith(color: colors.textSecondary),
            ),
            SizedBox(width: spacing.xs),
          ],
          Text(
            rating,
            style: typo.textMdSemibold.copyWith(color: colors.textPrimary),
          ),
          SizedBox(width: spacing.xs),
          Icon(Icons.star_rounded, size: 16, color: colors.borderPrimary),
        ],
      ),
    );
  }
}
