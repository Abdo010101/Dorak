import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Home/center specialty shortcut tile. Figma `294:8850`.
/// Icon tile (82×70) + label beneath.
class AppSpecialtyTile extends StatelessWidget {
  const AppSpecialtyTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final shadows = AppShadows.of(context);
    final spacing = AppSpacing.of(context);

    return SizedBox(
      width: 82,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: colors.white,
            borderRadius: BorderRadius.circular(radii.medium),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radii.medium),
              child: Container(
                height: 70,
                width: 82,
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(radii.medium),
                  border: Border.all(color: colors.fieldBorder),
                  boxShadow: shadows.card,
                ),
                alignment: Alignment.center,
                child: SizedBox(width: 28, height: 28, child: icon),
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          Text(
            label,
            textAlign: TextAlign.center,
            style: typo.textLgSemibold.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
