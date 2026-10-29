import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../domain/entities/center_entity.dart';

class CenterOffersSection extends StatelessWidget {
  const CenterOffersSection({
    super.key,
    required this.titleKey,
    required this.offers,
  });

  final String titleKey;
  final List<OfferEntity> offers;

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
          child: Text(titleKey.tr(),
              style: typo.titleSm.copyWith(color: colors.textPrimary)),
        ),
        SizedBox(height: spacing.lg),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: isRtl,
            itemCount: offers.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.lg),
            itemBuilder: (_, i) => _OfferCard(offer: offers[i]),
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});
  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final shadows = AppShadows.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      width: 342,
      padding: EdgeInsetsDirectional.all(spacing.sm),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(radii.large),
        border: Border.all(color: colors.fieldBorder),
        boxShadow: shadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(offer.title,
                        style: typo.titleSm.copyWith(color: colors.textPrimary)),
                    SizedBox(height: spacing.sm),
                    Text(offer.centerName,
                        style: typo.textMdRegular
                            .copyWith(color: colors.textSecondary)),
                  ],
                ),
                SizedBox(height: spacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppPricePill(value: offer.priceLabel),
                ),
                SizedBox(height: spacing.xs),
                Material(
                  color: colors.secondaryTint,
                  borderRadius: BorderRadius.circular(radii.medium),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(radii.medium),
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: Text(
                          'offer_details_cta'.tr(),
                          style: typo.textMdSemibold
                              .copyWith(color: colors.textInfo),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.sm + 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(radii.medium),
            child: Image.asset(
              offer.imageAsset,
              width: 128,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 128,
                color: colors.neutral50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
