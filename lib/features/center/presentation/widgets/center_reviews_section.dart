import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../domain/entities/center_entity.dart';

class CenterReviewsSection extends StatelessWidget {
  const CenterReviewsSection({
    super.key,
    required this.titleKey,
    required this.reviews,
  });

  final String titleKey;
  final List<ReviewEntity> reviews;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            titleKey.tr(args: [reviews.length.toString()]),
            style: typo.titleSm.copyWith(color: colors.textPrimary),
          ),
        ),
        SizedBox(height: spacing.lg),
        SizedBox(
          height: 134,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: isRtl,
            itemCount: reviews.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.lg),
            itemBuilder: (_, i) {
              final r = reviews[i];
              return AppReviewCard(
                reviewerName: r.reviewer,
                body: r.body,
                filled: r.filledStars,
              );
            },
          ),
        ),
      ],
    );
  }
}
