import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';
import '../buttons/app_primary_button.dart';
import '../buttons/app_secondary_button.dart';

/// Dialog with title, body, and up to 2 actions.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final bool destructive;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    VoidCallback? onConfirm,
    String? cancelLabel,
    VoidCallback? onCancel,
    bool destructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        cancelLabel: cancelLabel,
        onCancel: onCancel,
        destructive: destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return AlertDialog(
      title: Text(title, style: typo.titleSm.copyWith(color: colors.textPrimary)),
      content: Text(
        message,
        style: typo.textLgRegular.copyWith(color: colors.textPrimary),
      ),
      actions: [
        if (cancelLabel != null)
          AppSecondaryButton(
            label: cancelLabel!,
            expand: false,
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
          ),
        if (confirmLabel != null)
          AppPrimaryButton(
            label: confirmLabel!,
            expand: false,
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
          ),
      ],
    );
  }
}
