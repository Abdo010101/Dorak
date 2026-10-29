import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';

/// Distance tag + address title/body + location icon. Figma `175:911`.
class CenterInfoRow extends StatelessWidget {
  const CenterInfoRow({
    super.key,
    required this.titleKey,
    required this.address,
    required this.distanceKm,
  });

  final String titleKey;
  final String address;
  final String distanceKm;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined,
                size: 18, color: colors.borderPrimary),
            SizedBox(width: spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleKey.tr(),
                    style: typo.titleSm.copyWith(color: colors.textPrimary)),
                SizedBox(height: spacing.sm),
                Text(address,
                    style: typo.textLgRegular
                        .copyWith(color: colors.textSecondary)),
              ],
            ),
            SizedBox(width: spacing.md - 2),
          ],
        ),
        AppDistanceTag(label: 'center_distance_km'.tr(args: [distanceKm])),
      ],
    );
  }
}
