import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../domain/entities/center_entity.dart';

/// Doctor row card for center. Figma `423:10699`.
/// Leading "Book" button → middle info (name/specialty/rating) → trailing avatar.
class DoctorAtCenterCard extends StatelessWidget {
  const DoctorAtCenterCard({
    super.key,
    required this.doctor,
    required this.onBook,
    this.onTap,
  });

  final DoctorAtCenter doctor;
  final VoidCallback onBook;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final shadows = AppShadows.of(context);
    final spacing = AppSpacing.of(context);

    return Material(
      color: colors.white,
      borderRadius: BorderRadius.circular(radii.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.large),
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.md - 2, spacing.sm + 2, spacing.md, spacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(radii.large),
            border: Border.all(color: colors.fieldBorder),
            boxShadow: shadows.card,
          ),
          child: Row(
            children: [
              _SmallBookButton(onTap: onBook),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(doctor.name,
                        style: typo.titleSm.copyWith(color: colors.textPrimary)),
                    SizedBox(height: spacing.xs),
                    Text(doctor.specialty,
                        style: typo.textMdRegular
                            .copyWith(color: colors.textSecondary)),
                    SizedBox(height: spacing.xs),
                    AppRatingChip(
                      rating: doctor.ratingValue,
                      reviewCount: doctor.reviewsCount,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.md),
              AppAvatar(
                imageAsset: doctor.avatarAsset,
                size: 64,
                radius: radii.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallBookButton extends StatelessWidget {
  const _SmallBookButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Material(
      color: colors.borderPrimary,
      borderRadius: BorderRadius.circular(radii.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.medium),
        child: Container(
          height: 36,
          padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.lg - 2),
          alignment: Alignment.center,
          child: Text(
            'doctor_card_book'.tr(),
            style: typo.textMdSemibold.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
