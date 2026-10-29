import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Review card. Figma `402:4090`.
/// Horizontal-scrollable card (296×134) with rating + reviewer + body.
class AppReviewCard extends StatelessWidget {
  const AppReviewCard({
    super.key,
    required this.reviewerName,
    required this.body,
    required this.filled,
  });

  final String reviewerName;
  final String body;

  /// 0-5 full star count.
  final int filled;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final shadows = AppShadows.of(context);
    final spacing = AppSpacing.of(context);

    return Container(
      width: 296,
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(radii.large),
        border: Border.all(color: colors.fieldBorder),
        boxShadow: shadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reviewerName,
                style: typo.titleSm.copyWith(color: colors.textPrimary),
              ),
              _StarRow(filled: filled),
            ],
          ),
          SizedBox(height: spacing.lg),
          Text(
            body,
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: typo.textMdRegular.copyWith(
              color: colors.textSecondary,
              height: 1.69,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.filled});
  final int filled;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.md - 2,
        vertical: spacing.xs2,
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
        children: List.generate(5, (i) {
          final isFilled = i < filled;
          return Padding(
            padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : spacing.xs),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 16,
              color: colors.borderPrimary,
            ),
          );
        }),
      ),
    );
  }
}
