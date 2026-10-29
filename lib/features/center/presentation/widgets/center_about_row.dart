import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Icon + title/body row. Figma `175:923`.
class CenterAboutRow extends StatelessWidget {
  const CenterAboutRow({
    super.key,
    required this.titleKey,
    required this.body,
    this.icon = Icons.info_outline,
    this.leading,
  });

  final String titleKey;
  final String body;
  final IconData icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: spacing.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: colors.borderPrimary),
                  SizedBox(width: spacing.sm),
                  Text(titleKey.tr(),
                      style: typo.titleSm.copyWith(color: colors.textPrimary)),
                ],
              ),
              SizedBox(height: spacing.sm),
              Text(body,
                  textAlign: TextAlign.start,
                  style:
                      typo.textLgRegular.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
