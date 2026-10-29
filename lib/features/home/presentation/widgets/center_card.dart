import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';

class CenterCard extends StatelessWidget {
  const CenterCard({
    super.key,
    required this.name,
    required this.specialties,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageAsset,
    this.centerId = 1,
    this.isClinic = false,
  });

  final String name;
  final String specialties;
  final String location;
  final String rating;
  final String reviewCount;
  final String distance;
  final String imageAsset;
  final int centerId;
  final bool isClinic;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    final radius = BorderRadius.circular(radii.large);
    return Material(
      color: colors.white,
      elevation: 2,
      shadowColor: const Color(0x1F000000),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          debugPrint('[CenterCard tap] id=$centerId isClinic=$isClinic');
          context.pushNamed(
            isClinic ? RouteNames.clinicDetails : RouteNames.centerDetails,
            queryParameters: {'id': '$centerId'},
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: colors.fieldBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 175 / 96,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(radii.large),
                      ),
                      child: Image.asset(imageAsset, fit: BoxFit.cover),
                    ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: AppRatingChip(
                      rating: rating,
                      reviewCount: reviewCount,
                      background: colors.white,
                    ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: AppDistanceTag(label: distance),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.all(spacing.md - 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: typo.textLgSemibold.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: spacing.xs + 1),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondaryTint,
                        borderRadius: BorderRadius.circular(radii.small),
                      ),
                      child: Text(
                        specialties,
                        style: typo.textMdSemibold
                            .copyWith(color: colors.textInfo),
                      ),
                    ),
                    SizedBox(height: spacing.xs + 1),
                    Text(
                      location,
                      style: typo.textMdRegular
                          .copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.all(spacing.md - 2),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.secondaryTint,
                        borderRadius: BorderRadius.circular(radii.medium),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/home/call.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    SizedBox(width: spacing.xs2),
                    Expanded(
                      child: Container(
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.secondaryTint,
                          borderRadius: BorderRadius.circular(radii.medium),
                        ),
                        child: Text(
                          'center_card_details'.tr(),
                          style: typo.textMdSemibold.copyWith(
                            color: colors.textInfo,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
