import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';
import '../buttons/app_primary_button.dart';

/// Centered empty-state block with icon, title, body, optional CTA.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(height: 16)],
            Text(
              title,
              textAlign: TextAlign.center,
              style: typo.titleSm.copyWith(color: colors.textPrimary),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: typo.textLgRegular.copyWith(color: colors.textSecondary),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
