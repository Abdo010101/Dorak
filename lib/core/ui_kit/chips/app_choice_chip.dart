import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Selectable chip (single/multi choice). Figma `273:423`.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Material(
      color: selected ? colors.borderPrimary : colors.neutral25,
      borderRadius: BorderRadius.circular(radii.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.medium),
        child: Container(
          height: 40,
          padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radii.medium),
            border: selected ? null : Border.all(color: colors.fieldBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: typo.textLgSemibold.copyWith(
                color: selected ? colors.onPrimary : colors.textPrimary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
