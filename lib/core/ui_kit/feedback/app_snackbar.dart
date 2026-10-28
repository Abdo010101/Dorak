import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_typography.dart';

enum AppSnackbarKind { info, success, warning, error }

class AppSnackbar {
  const AppSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    AppSnackbarKind kind = AppSnackbarKind.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);

    final bg = switch (kind) {
      AppSnackbarKind.info => colors.textPrimary,
      AppSnackbarKind.success => colors.borderSuccess,
      AppSnackbarKind.warning => colors.borderWarning,
      AppSnackbarKind.error => colors.borderWarning,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: typo.textLgRegular.copyWith(color: colors.white),
        ),
        backgroundColor: bg,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.medium),
        ),
      ),
    );
  }
}
