import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Price pill (Primary-50 default). Figma `402:3877`.
class AppPricePill extends StatelessWidget {
  const AppPricePill({super.key, required this.value, this.background});

  final String value;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: spacing.xs + 1,
        vertical: spacing.xs - 2,
      ),
      decoration: BoxDecoration(
        color: background ?? colors.primaryTint,
        borderRadius: BorderRadius.circular(radii.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monetization_on_outlined,
              size: 18, color: colors.borderPrimary),
          SizedBox(width: spacing.xs),
          Text(
            value,
            style: typo.titleSm.copyWith(
              color: colors.borderPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: spacing.xs),
          Text(
            'sar_short'.tr(),
            style: typo.textMdSemibold.copyWith(color: colors.borderPrimary),
          ),
        ],
      ),
    );
  }
}
