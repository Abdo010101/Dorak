import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import 'app_empty_state.dart';

/// Error-state block. Icon tinted with DS warning color + retry CTA.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return AppEmptyState(
      title: title,
      message: message,
      icon: Icon(Icons.error_outline, size: 48, color: colors.borderWarning),
      actionLabel: onRetry != null ? (retryLabel ?? 'Retry') : null,
      onAction: onRetry,
    );
  }
}
