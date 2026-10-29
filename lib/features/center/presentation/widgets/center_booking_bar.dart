import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui_kit/ui_kit.dart';

/// Bottom booking bar: primary CTA + optional secondary CTA.
class CenterBookingBar extends StatelessWidget {
  const CenterBookingBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing.lg,
          spacing.lg,
          spacing.lg,
          spacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.white,
          boxShadow: [
            BoxShadow(
              color: colors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPrimaryButton(
              label: primaryLabel,
              leadingIcon: Icon(Icons.calendar_today_outlined,
                  size: 20, color: colors.onPrimary),
              onPressed: onPrimary,
            ),
            if (secondaryLabel != null) ...[
              SizedBox(height: spacing.sm),
              AppSecondaryButton(
                label: secondaryLabel!,
                onPressed: onSecondary ?? () {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}
