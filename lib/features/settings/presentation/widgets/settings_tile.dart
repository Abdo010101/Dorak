import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    final type = AppTypography.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: type.titleSm.copyWith(color: colors.textPrimary),
              ),
            ),
            if (trailing != null)
              IconTheme(
                data: IconThemeData(color: colors.textSecondary),
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
